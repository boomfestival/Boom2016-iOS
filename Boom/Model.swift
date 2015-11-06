//
//  Model.swift
//  Boom
//
//  Created by Florin Braghis on 10/18/15.
//  Copyright © 2015 CodeShaman. All rights reserved.
//

import SwiftyJSON
import RealmSwift
import AFNetworking



class Entry : Object {
	dynamic var key = ""
	dynamic var sectionClass = ""
}

class SectionItem : Object {
	dynamic var href = ""
	dynamic var imageURL = ""
	dynamic var title = ""
	
	func getFullImageURL() -> String{
		var imgURL = imageURL
		
		if !imgURL.hasPrefix("/") {
			imgURL = "/boom2016/site/assets/files/" + imageURL
		}
		
		return "https://www.boomfestival.org" + imgURL
	}
}

class SectionEntry : Entry {
	dynamic var title = ""
	let links = List<SectionItem>()
}

class ArticleEntry : Entry {
	dynamic var title = ""
	dynamic var imageURL = ""
	dynamic var body = ""	//html
	dynamic var classNames = ""
	
	func getImage() -> UIImage? {
		let name = imageURL.stringByReplacingOccurrencesOfString("/", withString: "_")
		return UIImage(named: name)
	}
	
	func getFullImageURL() -> String{
		var imgURL = imageURL
		
		if !imgURL.hasPrefix("/") {
			imgURL = "/boom2016/site/assets/files/" + imageURL
		}
		return imgURL
	}
}

class GalleryEntry : Entry {
	dynamic var galleryId = ""
	dynamic var title = ""
}

//MARK: Queries
extension Entry {
	
	static func cachedEntryWithKey(realm: Realm?, key: String) -> Entry? {
		//TODO: check expriation
		return entryWithKey(realm, key: key)
	}
	
	static func entryWithKey(realm: Realm?, key: String) -> Entry? {
		var entry: Entry?
		guard let realm = realm else {
			return nil
		}
		
		let sectionEntry = realm.objects(SectionEntry).filter("key='\(key)'")
		if sectionEntry.count > 0 {
			entry = sectionEntry.first
		}
		else {
			let detail = realm.objects(ArticleEntry).filter("key='\(key)'")
			if detail.count > 0{
				entry = detail.first
			}
		}

		if entry == nil {
			let gallery = realm.objects(GalleryEntry).filter("key='\(key)'")
			if gallery.count > 0 {
				entry = gallery.first
			}
		}
		return entry
	}
	
	static func keyFromPath(path: String) -> String {
		if (path.hasPrefix("/boom2016/")){
			let stripPath = path.stringByReplacingOccurrencesOfString("/boom2016/", withString: "")
			return stripPath
		}
		return path
		
	}
}





