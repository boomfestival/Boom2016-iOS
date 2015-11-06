//
//  GalleryViewController.swift
//  Boom
//
//  Created by Florin Braghis on 10/22/15.
//  Copyright © 2015 CodeShaman. All rights rese`rved.
//

import UIKit
import Alamofire
import MWPhotoBrowser
import SwiftSpinner

class BoomGalleryViewController: BoomViewController, MWPhotoBrowserDelegate {
	var photoBrowser: MWPhotoBrowser!
	var galleryId = ""
	var request: Request?
	var items: [NSDictionary] = []
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.view.backgroundColor = UIColor.blackColor()
		let url = "http://www.cincopa.com/media-platform/runtimeze/json.aspx?details=all&fid=" + self.galleryId
		NSLog("Loading gallery: \(url)")

		SwiftSpinner.show("Contacting mothership...")
		self.request = Alamofire.request(.GET, url).responseJSON { [weak self] (response) -> Void in
			SwiftSpinner.hide()
			guard case .Success(let json) = response.result else {
				if case .Failure(let err) = response.result {
					NSLog("Error: \(err)")
				}
				
				if let strongSelf = self {
					let message = UILabel()
					message.textColor = UIColor.whiteColor()
					message.text = "Sorry, this gallery is not available"
					strongSelf.view.addSubview(message)
					message.snp_makeConstraints(closure: { (make) -> Void in
						make.center.equalTo(strongSelf.view)
					})
				}
				return
			}
			
			if let items = json.valueForKey("items") as? [NSDictionary] {
				self?.items = items
				self?.createPhotoBrowser()
			}
			
			if let title = json.valueForKey("title") as? String {
				self?.setTitleText(title)
			}
		}
	}
	
	deinit {
		self.request?.cancel()
	}
	
	func createPhotoBrowser(){
		photoBrowser = MWPhotoBrowser(delegate: self)
		photoBrowser.displayActionButton = false
		photoBrowser.displayNavArrows = false
		photoBrowser.displaySelectionButtons = false
		photoBrowser.zoomPhotosToFill = true
		photoBrowser.alwaysShowControls = false
		photoBrowser.enableGrid = true
		photoBrowser.startOnGrid = true
		self.addChildViewController(photoBrowser)
		self.view.addSubview(photoBrowser.view)
		photoBrowser.view.snp_makeConstraints { (make) -> Void in
			make.edges.equalTo(self.view)
		}
	}
	
	func numberOfPhotosInPhotoBrowser(photoBrowser: MWPhotoBrowser!) -> UInt {
		return UInt(self.items.count)
	}
	
	
	func photoBrowser(photoBrowser: MWPhotoBrowser!, thumbPhotoAtIndex index: UInt) -> MWPhotoProtocol! {
		let item = self.items[Int(index)]
		
		if let url = item["thumbnail_url"] as? String {
			let thumb = MWPhoto(URL: NSURL(string: url))
			return thumb
		}
		
		let notFoundImage = UIImage()
		return MWPhoto(image: notFoundImage)
	}
	
	func photoBrowser(photoBrowser: MWPhotoBrowser!, photoAtIndex index: UInt) -> MWPhotoProtocol! {
		let item = self.items[Int(index)]
		
		if let url = item["content_url"] as? String {
			let photo = MWPhoto(URL: NSURL(string: url))
			return photo
		}
		return MWPhoto(image: UIImage())
	}
}
