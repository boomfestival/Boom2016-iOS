//
//  BoomMenuCollectionViewController.swift
//  Boom
//
//  Created by Florin Braghis on 11/3/15.
//  Copyright © 2015 CodeShaman. All rights reserved.
//

import UIKit


struct MenuItem {
	var title = ""
	var sectionColor = UIColor.blackColor()
	var textColor = UIColor.blackColor() //text color when background is color
	
	init(_ title: String, _ sectionColor: UInt, _ textColor: UInt) {
		self.title = title
		self.sectionColor = UIColor(rgbValue: sectionColor)
		self.textColor = UIColor(rgbValue: textColor)
	}
}

protocol BoomMenuDelegate {
	func didSelectMenuItem(menuItem: MenuItem)
	func didTapMenuLogo()
}

class BoomMenuCollectionViewController : UICollectionViewController, UICollectionViewDelegateFlowLayout {
	var menuItems: [MenuItem] = []
	var delegate: BoomMenuDelegate?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		collectionView?.backgroundColor = UIColor.clearColor()
		collectionView?.registerClass(BoomMenuCollectionViewCell.self, forCellWithReuseIdentifier: "menuItemCell")
		collectionView?.registerClass(BoomCellWithImageView.self, forCellWithReuseIdentifier: "menuLogoCell")
	}
	
	override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
		return 2
	}
	
	override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		if section == 0 {
			return 1
		}
		return self.menuItems.count
	}
	
	override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {

		if indexPath.section == 0 {
			let cell = self.collectionView?.dequeueReusableCellWithReuseIdentifier("menuLogoCell", forIndexPath: indexPath) as! BoomCellWithImageView
			cell.imageView.image = UIImage(named: "boom2016-logo-home")
			cell.imageView.contentMode = .ScaleAspectFit
			return cell
		}
		
		let cell = self.collectionView?.dequeueReusableCellWithReuseIdentifier("menuItemCell", forIndexPath: indexPath) as! BoomMenuCollectionViewCell
		cell.titleLabel.text = menuItems[indexPath.row].title
		let color = menuItems[indexPath.row].sectionColor
		cell.titleLabel.textColor = color
		cell.animateAppearance(indexPath.row)
		return cell
	}
	
	override func collectionView(collectionView: UICollectionView, didHighlightItemAtIndexPath indexPath: NSIndexPath) {
		if indexPath.section == 0 {
			return
		}
		
		let cell = self.collectionView?.cellForItemAtIndexPath(indexPath) as! BoomMenuCollectionViewCell
		cell.titleLabel.textColor = UIColor.whiteColor()
		cell.animatePress()
	}
	
	override func collectionView(collectionView: UICollectionView, didUnhighlightItemAtIndexPath indexPath: NSIndexPath) {
		if indexPath.section == 0 {
			return
		}

		let cell = self.collectionView?.cellForItemAtIndexPath(indexPath) as! BoomMenuCollectionViewCell
		cell.animateUnpress()
		let color = menuItems[indexPath.row].sectionColor
		cell.titleLabel.textColor = color
		
	}
	
	override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
		if indexPath.section == 0 {
			delegate?.didTapMenuLogo()
			return
		}

		let item = menuItems[indexPath.row]
		delegate?.didSelectMenuItem(item)
	}
	
	func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
		
		let frame = self.view.bounds

		if indexPath.section == 0 {
			return CGSizeMake(frame.width, 150)
		}

		return CGSizeMake(frame.width, 35)
	}
	
	func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
		if section == 0 {
			return UIEdgeInsetsMake(20, 0, 0, 0)
		}
		return UIEdgeInsetsZero
	}
}
