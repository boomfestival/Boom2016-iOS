"use strict"

let loadUrl = require('./load-url')
let EventEmitter = require('events').EventEmitter
let parseItem = require('./boom-parse-item')


class Spider extends EventEmitter {

	constructor(cache){
		super()
		this.cache = cache
		this.stopOnError = false
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

	makeHandler(key) {
		return function(err, data){
			if (err){
				console.log("Error loading: ", key, " -> ", err)
				this.emit('error', err)
				if (this.stopOnError){
					console.log("STOP: Spider: Stopping because of error.")
					return
				}

			} else {
				let item = parseItem(data)
				if (item && this.cache){
					this.cache.saveToCache(key, item)
				}				
				this.emit('item', key, item)
			}
			this.getNext()
		}.bind(this)		
	}

	getKey(key) {
		let nextURL = "https://boomfestival.org/boom2016/" + key + "?ajax=yes"

		let cached = this.cache ? this.cache.queryCache(key) : null
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