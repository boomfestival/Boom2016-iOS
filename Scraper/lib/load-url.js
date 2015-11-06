"use strict"

var	request = require('request')
//Download and converts a rss channel url into a JSON representation
let loadUrl = function(url, callback) {
	let req = request(url, function(err, response, body){

		if (response.statusCode != 200){
			err = "Invalid response code: " + response.statusCode
		}

		if (err != null){
			return callback(err)
		}
		callback(null, body)
	})
}

module.exports = loadUrl


