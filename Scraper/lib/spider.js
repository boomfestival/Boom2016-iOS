"use strict"

let loadUrl = require('./load-url')
let EventEmitter = require('events').EventEmitter
let parseItem = require('./boom-parse-item')
let _ = require('underscore')


class Spider extends EventEmitter {

	constructor(cache){
		super()
		this.cache = cache
		this.useCache = false
		this.useCacheOnError = true
	}

	run(urls) {
		this.queue = urls.slice()
		this.getNext()
	}

	getNext(){
		if (this.queue.length){
			let nextKey = this.queue.shift()
			this.getKey(nextKey)
		}
		else {
			this.emit('finished')
		}		
	}

	onServerError(err, key) {
		console.log("Error loading: ", key, " -> ", err)
		this.emit('error', err)
		if (this.stopOnError){
			console.log("STOP: Spider: Stopping because of error.")
			return true
		}

		var item = null

		if (this.useCacheOnError && this.cache){
			item = this.cache.queryCache(key)
			if (item) {
				console.log("Using cached version for key ", key)
			}
		}
		this.emit('item', key, item)
	}

	makeHandler(key) {
		return function(err, data){
			if (err){
				if (this.onServerError(err, key) == true) {
					return
				}
			} else {
				let item = parseItem(data)
				this.saveToCacheIfGood(key, item)
				this.emit('item', key, item)
			}
			this.getNext()
		}.bind(this)		
	}

	saveToCacheIfGood(key, item) {
		//Saves regardless if cache enabled or not
		if (this.cache && !_.isEmpty(item)){
			console.log('Saving to cache: ', key)
			this.cache.saveToCache(key, item)
		}
	}

	getCached(key) {
		if (this.useCache && this.cache) {
			return this.cache.queryCache(key)
		}
		return null
	}

	getKey(key) {
		let nextURL = "https://boomfestival.org/boom2016/" + key + "?ajax=yes"

		let cached = this.getCached(key)

		if (cached) {
			this.emit('item', key, cached)
			this.getNext()
		}
		else {
			let handler = this.makeHandler(key)
			loadUrl(nextURL, handler)
		}
	}
}

module.exports = Spider