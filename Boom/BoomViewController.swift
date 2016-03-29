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
    var realmNotification: RLMNotificationToken?
    var entry: Entry?
    var entryKey: String = ""
    

    init()
    {
        super.init(nibName: nil, bundle: nil)
        realmNotification = Model.realm!.addNotificationBlock { [weak self] notification, realm in
            if let strongSelf = self
            {
                strongSelf.loadKey()
            }
        }
    }
    
    convenience init(key: String)
    {
        self.init()
        self.entryKey = key
        loadKey()
    }
    
    convenience init(entry: Entry)
    {
        self.init()
        self.entry = entry
        self.entryKey = entry.key
    }
    
    deinit
    {
        realmNotification?.stop()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadKey()
    {
        guard let res = Entry.entryWithKey(Model.realm, key: self.entryKey) else
        {
            print("Entry is not available", self.entryKey)
            self.dismissViewControllerAnimated(true, completion: nil)
            return
        }
        self.entry = res
        entryDidChange()
    }
    
    func entryDidChange() {}
    
	static func viewControllerForEntry(entry: Entry?) -> BoomViewController? {
		guard let entry = entry else {
			return nil
		}
		
		var vc: BoomViewController?
		if entry is SectionEntry {
			
            let sectionVC = BoomSectionViewController(entry: entry)
			vc = sectionVC
		}
		else if entry is ArticleEntry {
			vc = BoomArticleViewController(entry: entry)
		}
		else if entry is GalleryEntry {
			let gallery = entry as! GalleryEntry
            let galVC = BoomGalleryViewController(entry: entry)
			galVC.galleryId = gallery.galleryId
			vc = galVC
			
		}
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