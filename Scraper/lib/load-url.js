"use strict"

var	request = require('request')
//Download and converts a rss channel url into a JSON representation
let loadUrl = function(url, callback) {
	let req = request(url, function(err, response, body){
		if (err != null){
			return callback(err)
		}

		if (response.statusCode != 200){
			err = "Invalid response code: " + response.statusCode
			return callback(null, body)
		}
		
		callback(null, body)
	})
}

module.exports = loadUrl


