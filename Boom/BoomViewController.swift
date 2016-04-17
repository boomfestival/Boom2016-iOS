//
//  BoomViewController.swift
//  Boom
//
//  Created by Florin Braghis on 10/20/15.
//  Copyright © 2015 CodeShaman. All rights reserved.
//


import UIKit
import Realm

import SwiftSpinner

class BoomViewController : UIViewController {
	
	var sectionColor = UIColor.blueColor()
	var sectionTextColor = UIColor.whiteColor()
    var entryKey: String = ""
    

    init()
    {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
	static func viewControllerForEntry(entry: Entry?) -> BoomViewController? {
		guard let entry = entry else {
			return nil
		}
		
		var vc: BoomViewController?
		if entry is SectionEntry {
			
            let sectionViewController = BoomSectionViewController()
            sectionViewController.section = entry as! SectionEntry
			vc = sectionViewController
		}
		else if entry is ArticleEntry {
			let articleViewController = BoomArticleViewController()
            articleViewController.article = entry as! ArticleEntry
            vc = articleViewController
		}
		else if entry is GalleryEntry {
            let galleryViewController = BoomGalleryViewController()
            let gallery = entry as! GalleryEntry
            galleryViewController.galleryId = gallery.galleryId
			vc = galleryViewController
			
		}
        vc?.entryKey = entry.key
		return vc
	}
    
    
}

public func executeAfter(delay:Double, closure:()->()) {
	dispatch_after(
		dispatch_time(
			DISPATCH_TIME_NOW,
			Int64(delay * Double(NSEC_PER_SEC))
		),
		dispatch_get_main_queue(), closure)
}

extension UIViewController {
	class func viewControllerForKey(key: String, callback: (viewController: UIViewController?) -> Void) {
		Entry.fromKey(key) {(err, entry) -> Void in
			guard err == nil else {
				NSLog("Key \(key) error: \(err)")
				callback(viewController: nil)
				return
			}
			let vc = BoomViewController.viewControllerForEntry(entry)
			callback(viewController: vc)
		}
	}
}