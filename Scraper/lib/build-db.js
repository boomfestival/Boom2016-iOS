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
	var cache = null

	if (options.cache){
		cache = new Cache('/tmp/boomproxy/cache', true)
	}


	let conv = new Spider(cache)

//-------- REFACTOR: Move into Spider
// Spider should have a 'current' version of the db
// If an error occurs when item is loaded, spider should use the old version
// OR
// If a load error occurs, use cached version
// Cache is useless anyway .
	let Results = {}

	conv.on('item', function(key, item) {
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
					conv.queue.push(href)
				}
			})
		}
	})

	conv.on('finished', function(){
		saveAsJson(options.output, Results)
		callback(null)
	})

	conv.on('error', function(){
	})
//---------------- 

	return conv
}

module.exports = build
