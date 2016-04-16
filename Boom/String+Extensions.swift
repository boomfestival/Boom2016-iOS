//
//  String+Extensions.swift
//  Boom
//
//  Created by Florin Braghis on 10/21/15.
//  Copyright © 2015 CodeShaman. All rights reserved.
//

import UIKit

extension String {
	init(htmlEncodedString: String) {
		let encodedData = htmlEncodedString.dataUsingEncoding(NSUTF8StringEncoding)!
		let attributedOptions : [String: AnyObject] = [
			NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
			NSCharacterEncodingDocumentAttribute: NSUTF8StringEncoding
		]
		
		var attributedString: NSAttributedString?
		
		do {
			attributedString =  try NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil)
		} catch (_) {}
		
		
		self.init(attributedString?.string ?? "")
	}
}


extension String {
	func escapeForJavascriptCall () -> String? {
		var result: String?
		do {
			let options = NSJSONWritingOptions()
			let escaped = try NSJSONSerialization.dataWithJSONObject([self], options: options)
			if let jsonString = String(data: escaped, encoding: NSUTF8StringEncoding) {
				let endIndex = jsonString.endIndex.advancedBy(-4)
				let startIndex = jsonString.startIndex.advancedBy(2)
				result = jsonString.substringWithRange(Range<String.Index>(start: startIndex, end: endIndex)) //NB: what an abomination! Swift, come on!
			}
		} catch (_) {}

		return result
	}
}

extension String
{
    static func contentsOfTextFile(name: String) -> String
    {
        guard let path = NSBundle.mainBundle().pathForResource(name, ofType: "txt") else {
            NSLog("Path not found: %s", name)
            return ""
        }
        
        guard let result = try? String(contentsOfFile: path) else
        {
            NSLog("Could not load contents of: %s", path)
            return ""
        }
        return result
    }
}