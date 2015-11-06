//
//  Model+AF.swift
//  Boom
//
//  Created by Florin Braghis on 10/20/15.
//  Copyright © 2015 CodeShaman. All rights reserved.
//

import RealmSwift
import Alamofire
import HTMLReader
import SwiftSpinner

extension Entry {
	
	
	static func absolueUrlForEntry(key: String) -> String {
		var path = key
		if !key.hasPrefix("/boom2016/") {
			path = "/boom2016/" + key
		}
		
		if !key.hasSuffix("/"){
			path += "/"
		}

		return "https://www.boomfestival.org\(path)"
	}
	
	class func fromKey(key: String, callback: (err: NSError?, entry: Entry?) -> Void) {
		
		let cached = Entry.cachedEntryWithKey(Model.realm, key: key)
		
		if cached != nil {
			callback(err: nil, entry: cached)
			return
		}
		
		
		let url = Entry.absolueUrlForEntry(key)
		
		SwiftSpinner.showWithDelay(0.0, title: "Contacting mothership...")
		
		Alamofire.request(.GET, url, parameters: ["ajax": "yes"])
			.response { request, response, data, error in
				
				SwiftSpinner.hide()
				
				guard response?.statusCode == 200 else {
					NSLog("Error loading \(request?.URL?.absoluteString)")
					NSLog("Response: \(response)")
					callback(err: error, entry: nil)
					return
				}
				
				guard let data = data else {
					NSLog("Response data is nil")
					callback(err: error, entry: nil)
					return
				}
				let entry = Entry.fromHTML(data)
				entry?.key = key
				callback(err: nil, entry: entry)
		}
	}
	
	class func fromHTML(html: NSData) -> Entry? {
		
		var entry: Entry?
		
		let document = HTMLDocument(data: html, contentTypeHeader:  "text/html")
		if let detailTag = document.firstNodeMatchingSelector(".detail") {
			if detailTag.hasClass("gallery"){
				entry = GalleryEntry.extractFromHtmlText(html)
			}
			else {
				entry = ArticleEntry.fromHTMLDocument(document)
			}
		}
		else {
			if document.firstNodeMatchingSelector(".eight.columns") != nil {
					entry = SectionEntry.fromHTMLDocument(document)
			}
		}
		return entry
	}
}


extension SectionEntry {
	
	static func fromHTMLDocument(document: HTMLDocument) -> SectionEntry? {
		let linkTags = document.nodesMatchingSelector(".eight.columns")
		return SectionEntry.fromHTMLTags(linkTags)
	}
	
	static func fromHTMLTags(linksTag: [AnyObject]) -> SectionEntry? {
		var sectionEntry: SectionEntry?
		
		if  linksTag.count > 0 {
			let elems = linksTag.map { $0 as? HTMLElement }.filter { $0 != nil }.map { $0! }
			let linkEntries = elems.map { tag -> SectionItem in
				let sectionItem = SectionItem()
				let aTag = tag.firstNodeMatchingSelector("a")
				if let href = aTag?.attributes["href"] as? String {
					sectionItem.href = href
					
					if let img = aTag?.firstNodeMatchingSelector("img"), src = img.attributes["src"] as? String {
						sectionItem.imageURL = src
					}
					
					if let pageTitle = aTag?.firstNodeMatchingSelector(".page-title")?.textContent {
						sectionItem.title = pageTitle
					}
				}
				return sectionItem
			}
			sectionEntry = SectionEntry()
			sectionEntry?.links.appendContentsOf(linkEntries)
		}
		return sectionEntry
	}
}


extension ArticleEntry {

	class func fromHTMLDocument(document: HTMLDocument) -> ArticleEntry {
		
		let articleEntry = ArticleEntry()
		
		if let pageTitleTag = document.firstNodeMatchingSelector("h3.page-title") {
			articleEntry.title = pageTitleTag.textContent
		}
		
		if let detailTag = document.firstNodeMatchingSelector(".detail") {
			if let classNames = detailTag.attributes["class"] as? String {
				articleEntry.classNames = classNames
			}
		}
		
		if let img = document.firstNodeMatchingSelector(".page-top-image img") {
			if let url = img.attributes["src"] as? String {
				articleEntry.imageURL = url
			}
		}
		
		if let pageBody = document.firstNodeMatchingSelector(".page-body") {
			articleEntry.body = pageBody.innerHTML
		}
		return articleEntry
	}
}

func matchesForRegexInText(regex: String, text: String, groupIndex: Int = 0) -> [String] {
	
	do {
		let options = NSRegularExpressionOptions()
		let regex = try NSRegularExpression(pattern: regex, options: options)
		let nsString = text as NSString
		let matching_options = NSMatchingOptions()
		let results = regex.matchesInString(text, options: matching_options, range: NSMakeRange(0, nsString.length)) 
		return results.map { (match) in
			let group1 = match.rangeAtIndex(1)
			return nsString.substringWithRange(group1)
		}

	} catch (_) {}
	
	return []
}

extension GalleryEntry {
	
	class func extractFromHtmlText(html: NSData) -> GalleryEntry?{
		var result: GalleryEntry?
		if let str = String(data: html, encoding: NSUTF8StringEncoding) {
			//let match = data.match(/cpo\[\"_fid\"\]\s*\=\s*\"(.+?)\"/)
			let matches = matchesForRegexInText("cpo\\[\\\"_fid\\\"\\]\\s*\\=\\s*\\\"(.+?)\\\"", text: str, groupIndex: 1)
			if matches.count > 0 {
				result = GalleryEntry()
				result!.galleryId = matches.first!
			}
		}
		return result
	}
}