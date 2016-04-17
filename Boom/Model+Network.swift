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
		
        NSLog("fromKey: \(key)");
		if cached != nil {
            NSLog("Cached => \(key)");
			callback(err: nil, entry: cached)
			return
		}
		
        let err = NSError(domain: "", code: NSNotFound, userInfo: nil)
        callback(err: err, entry: nil)
    }
}
