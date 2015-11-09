"use strict"

let Spider = require('./spider')
let path = require('path')
let Cache = require('./cache')

function computeHash(data) {
	return require('crypto').createHash('md5').update(data).digest('hex')
}

function saveAsJson(filename, data) {

	var existingHash = ""
	try {
		console.log("Trying to open existing file: " + filename)
		let existingData = require('fs').readFileSync(filename)
		if (existingData) {
			existingHash = computeHash(existingData.toString())
			console.log("Existing hash: ", existingHash)
		}
	}
	catch (e){
		console.log("Could not open.")
	}

	let outputJSONString = JSON.stringify(data, undefined, 2)

	let outputHash = computeHash(outputJSONString)
	console.log("Output hash: ", outputHash)

	if (outputHash != existingHash){
		require('fs').writeFileSync(filename, outputJSONString)		
		console.log("File written.")
	}
	else {
		console.log("Contents didn't change. Not overwriting.")
	}
}

function build(options, callback) {

	let cache = new Cache('/tmp/boomproxy/cache', true)
	let spider = new Spider(cache)

	spider.useCache = options.cache
	spider.useCacheOnError = options.cacheOnError

	let Results = {}

	spider.on('item', function(key, item) {
		if (!item){
			return
		}
		console.log (key, ' => ', item.type)
		Results[key] = item
		if (item.type == 'section'){
			item.links.map(function(link){
				let href = link.href
				if (!Results[href]){
					console.log("Discovered ", href)
					spider.queue.push(href)
				}
			})
		}
	})

	spider.on('finished', function(){
		saveAsJson(options.output, Results)
		callback(null)
	})

	spider.on('error', function(){
	})
//---------------- 

	return spider
}

module.exports = build
