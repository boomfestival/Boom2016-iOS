//
//  Model+JSON.swift
//  Boom
//
//  Created by Florin Braghis on 10/21/15.
//  Copyright © 2015 CodeShaman. All rights reserved.
//  Mandatory payment license

import SwiftyJSON
import RealmSwift

func strtrim(s: String) -> String
{
    return s.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet());
}

extension JSON
{
    func htmlUnescapeString(key: String) -> String
    {
        let tempStr = self[key].string ?? ""
        let escapedStr = String(htmlEncodedString: tempStr)
        return escapedStr
    }
}

extension Entry
{
    static func adjustKey(key: String) -> String
    {
        var s = key;
        if s.hasSuffix("/") {
            s = String(key.characters.dropLast())
        }
        
        if s.hasPrefix("/")
        {
            s = String(key.characters.dropFirst());
        }
        
        return s
    }
}


extension SectionItem {
    
	convenience init(json: JSON){
		self.init()
        title = json.htmlUnescapeString("title")
        href = json["href"].string ?? ""
        href = Entry.adjustKey(href);
        imageURL = json["imageURL"].string ?? ""
	}
}

extension SectionEntry {
	convenience init(key: String, json: JSON){
		self.init()
		self.key = key
		let jsonLinks = json["links"]
		for (_, link):(String, JSON) in jsonLinks {
			let sectionItem = SectionItem(json: link)
			self.links.append(sectionItem)
		}
	}
}

extension ArticleEntry {
	convenience init(key: String, json: JSON){
		self.init()
		self.key = key
        title = json.htmlUnescapeString("title")
        imageURL = json["imageURL"].string ?? ""
		body = json["body"].string ?? ""
		classNames = json["className"].string ?? "columns sixteen detail"
	}
}

extension GalleryEntry {
	convenience init(key: String, json: JSON){
		self.init()
		self.key = key
        self.galleryId = strtrim(json["galleryId"].string ?? "")
        self.title = strtrim(json["title"].string ?? "")
	}
}

extension Entry {
	
	static func fromJSON(key: String, item: JSON) -> Entry? {
		
		if let itemType = item["type"].string {
			
			switch itemType{
			case "article":
				let article = ArticleEntry(key: key, json: item)
				return article
			case "section":
				let sectionItem = SectionEntry(key: key, json: item)
				return sectionItem
			case "gallery":
				let galleryItem = GalleryEntry(key: key, json: item)
				return galleryItem
				
			default:
				break
			}
		}
		return nil
	}
	
}

import Alamofire



class Model {

    static var dbURL = "https://www.boomfestival.org/boom2016/mobile-app/feed4iosapp/"
    static var realm: Realm?
    static var isDevMode = false
	
	static func updateIfNecessary(callback: ((err: NSError?)->Void)?) {

		NSLog("Model.updateIfNecessary() running")

		
		let url = Model.dbURL
		//TODO: check age or version or something.
		Alamofire.request(.GET, url, parameters: ["ajax": "yes"])
			.response { request, response, data, error in
				
				guard response?.statusCode == 200 else {
					NSLog("Error loading \(request?.URL?.absoluteString)")
					NSLog("Response: \(response)")
					callback?(err: error)
					return
				}
                
				guard let data = data else {
					NSLog("Response data is nil")
					callback?(err: error)
					return
				}
                
                asyncImportJSON(data)
		}
	}
    
    static func createCopy(realm: Realm) -> Bool
    {
        NSLog("Creating database copy")

        func bundlePath(path: String) -> String? {
            let resourcePath = NSBundle.mainBundle().resourcePath as NSString?
            return resourcePath?.stringByAppendingPathComponent(path)
        }
        
        if let backupPath = bundlePath("seed.realm")
        {
            do
            {
                try NSFileManager.defaultManager().removeItemAtPath(backupPath)
                try realm.writeCopyToPath(backupPath)
                NSLog("Created database copy at \(backupPath)")
                return true

            }
            catch
            {
                NSLog("Could not create database copy: \(error)")
            }
        }
        return false
    }
    
    static func asyncImportJSON(data: NSData)
    {

        dispatch_async(dispatch_queue_create("background", nil), {
            NSLog("Async importing JSON...")
            
            guard let queueRealm = try? Realm() else
            {
                NSLog("Error creating background realm..")
                return;
            }
            
            importJSON(queueRealm, data: data)
            
            if isDevMode {
                createCopy(queueRealm)
            }
            NSLog("Async import finished.")
        })

    }
    
    
	private static func importJSON(realm: Realm, data: NSData){
		var count = 0
		let json = JSON(data: data)
        
        do
        {
            try realm.write {
                realm.deleteAll()
                for (var key,item):(String, JSON) in json {
                    
                    key = Entry.adjustKey(key)
                    
                    if let entry = Entry.fromJSON(key, item: item){
                        
                        NSLog("key=\(entry.key)");
                        count += 1
                        realm.add(entry)
                    }
                }
                do
                {
                   try realm.commitWrite()
                }
                catch _
                {
                    NSLog("Error: Realm commit write failed")
                }
            }

        } catch _ {
            NSLog("Error: Realm write failed")
        }
        
		NSLog("importFromJSONData: imported \(count) entries.")
	}
}
