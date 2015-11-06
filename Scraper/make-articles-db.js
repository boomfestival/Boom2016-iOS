/*
	Author: Florin Braghis - florin.braghis@gmail.com
	Spiders the www.boomfestival.org website and extracts all the articles.
	Produces a json file to be used by the Boom Festival iOS application

	Usage:

		node make-articles-db.js [--no-cache] [-output=filename] [-every=seconds]
*/
"use strict"

let minimist = require('minimist')
let _ = require('underscore')

//==========

let defaultOptions = {
	cache: true,
	output: './results.json',
	every: 0
}

let argv = minimist(process.argv)
let options = _.extend(defaultOptions, argv)

console.log(options)

var runs = 0 

function run(options) {
	runs++

	console.log(runs + ". Starting.")

	let articleBuilder = require('./lib/build-db')

	let dbBuilder = articleBuilder(options, function(){
		console.log(runs + ". All done.")
		if (options.every == 0){
			process.exit(0)
		} else {
			console.log(runs + ". Repeating after " + options.every + " seconds")
			setTimeout(function(){run(options)}, options.every * 1000)
		}
	})

	dbBuilder.run(["news", "environment", "program", "boomguide", "participate", "tickets", "gallery"])
}

run(options)

