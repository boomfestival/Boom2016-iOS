"use strict"
let cheerio = require('cheerio')


function shortenImageURL(imageURL) {
	if (imageURL)
		return imageURL.replace('/boom2016/site/assets/files/', '')
}

function shortenLinkHref(link) {
	return link.replace('/boom2016/', '')
}

//Gallery is included as a Javascript string
function getExternalGalleryId(data) {
	let match = data.match(/cpo\[\"_fid\"\]\s*\=\s*\"(.+?)\"/)
	if (match && match.length > 1){
		return match[1]
	}
	return null
}

//Parse a boom page result (which is returned by the server in response to a request to a URL with ?ajax=true query param)
//For example: https://www.boomfestival.org/boom2016/participate/?ajax=true
//Returns an object, which is either a list or a detail item (.type)
function boom_parseItem(data) {
	let $ = cheerio.load(data)
	var result = {}
	let detailTag = $('.detail')
	if (detailTag.length > 0) {
		if (detailTag.is(".gallery")){
			result['type'] = 'gallery'
			result['galleryId'] = getExternalGalleryId(data)
			return result
		}

		result['type'] = 'article'
		result['className'] = detailTag.attr('class')

		let pageTopImage = $('.page-top-image img').first()

		if (pageTopImage){
			let imageURL = pageTopImage.attr('src')
			result['imageURL'] = imageURL
		}

		let pageTitle = $('h3.page-title').first()

		if (pageTitle){
			result['title'] = pageTitle.html()
		}

		let pageBody = $('.page-body').first()

		if (pageBody) {
			result['body'] = pageBody.html()
		}
	} else {
		let links = $('.eight.columns.teaser')
		if (links.length > 0){
			result['type'] = 'section'
			result['links'] = links.map(function(i, div){ 
				let link = {}
				let aTag = $('a', this).first()
				if (aTag){
					link.href = aTag.attr('href')

					if (link.href){
						link.href = shortenLinkHref(link.href)
					}

					let img = $('img', aTag).first()
					if (img){
						link.imageURL = shortenImageURL(img.attr('src'))
					}

					let pageTitle = $('.page-title', aTag).first()
					if (pageTitle){
						link.title = pageTitle.text()
					}
				}
				return link
			}).get()
		}
	}

	return result	
}
module.exports = boom_parseItem