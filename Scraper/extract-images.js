"use strict"

let _ 	= require('underscore'),
request = require('request'),
path = require('path'), 
fs = require('fs'), 
mkdirp = require('mkdirp')

function assetURL(asset){
	if asset[0] == '/' 
		return `https://www.boomfestival.org${asset}`
	return `https://www.boomfestival.org/boom2016/site/assets/files/${asset}`
}

let downloadFile = function(uri, filename, callback){
  request.head(uri, function(err, res, body){
    request(uri).pipe(fs.createWriteStream(filename)).on('close', callback);
  });
};

function downloadBoomAsset(folder, asset, callback) {
	//=="1016/bf2014_muriloganesh-1024.564x264.jpg"
	let localPath = asset.replace(/\//g, '_')
	let filename = path.join(folder, localPath)
	let url = assetURL(asset)
	console.log("Downloading ", url, " to ", filename)
	downloadFile(url, filename, callback)
}

class BoomAssetDownloader extends require('events').EventEmitter {
	constructor(folder, assets){
		super()
		try {
			mkdirp(folder)
		} catch(e) {}

		this.folder = folder
		this.queue = assets.slice()
		this.active = 0
	}

	start(numThreads){
		let threads = numThreads | 1
		for (var k = 0; k < threads; k++){
			this.next()
		}
	}

	next() {
		if (this.queue.length > 0){
			this.active++
			let next = this.queue.shift()
			downloadBoomAsset(this.folder, next, this.done.bind(this))
		} else {
			if (this.active == 0)
				this.emit("done")
		}
	}
	done(err){
		this.active--
		if (err){
			console.log("Error: ", err)
		}
		this.next()
	}
}

function downloadSectionImages(results, callback){
	function extractSectionImages(results) {
		var images = _(results)
			.filter(function(val) { return val.type == "section"})
			.map(function(item){ return item.links })
			.map(function(links) { 
				return _(links).map(function(link){
					return link.imageURL
				})
			})
		images = _.flatten(images)	
		return images
	}

	let images = extractSectionImages(results)
	let downloader = new BoomAssetDownloader("./images/sections", images)
	downloader.start(4)
	downloader.on("done", function(){
		callback()
	})
}

function downloadArticleImages(results, callback){
	function extractArticleImages(results){
		var images = _(results)
			.filter(function(val){return val.type == "article"})
			.map(function(item){return item.imageURL})
			.filter(function(val){return val != null})
		return images
	}

	let images = extractArticleImages(results)
	let downloader = new BoomAssetDownloader("./images/articles", images)
	downloader.start(4)
	downloader.on("done", function(){
		callback()
	})

}

downloadSectionImages(require('./results.json'), function(){
	console.log("Section images downloaded.")
	
	// downloadArticleImages(require('./results.json'), function(){
	// 	console.log("Article images downloaded.")
	// })
})





