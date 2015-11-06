//
//  BoomSectionCollectionViewController.swift
//  Boom
//
//  Created by Florin Braghis on 11/3/15.
//  Copyright © 2015 CodeShaman. All rights reserved.
//

import UIKit
import RealmSwift
import SDWebImage

protocol BoomSectionDelegate {
	func didSelectItem(item: SectionItem)
}

class BoomListCollectionViewController : UICollectionViewController{
	var cellBackgroundColor = UIColor.magentaColor()
	var cellTextColor = UIColor.whiteColor()
	var items: List<SectionItem>!
	var delegate: BoomSectionDelegate?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		collectionView?.backgroundColor = UIColor.clearColor()
		collectionView?.registerClass(BoomSectionCollectionViewCell.self, forCellWithReuseIdentifier: "boomSectionCell")
	}
	
	override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
		return 1
	}
	
	override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return items.count
	}
	
	override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier("boomSectionCell", forIndexPath: indexPath) as! BoomSectionCollectionViewCell
		
		let item = items[indexPath.row]
		let title = item.title
		let url = NSURL(string: item.getFullImageURL())
		
		cell.roundedImageView.imageView.sd_setImageWithURL(url) { _ in
			cell.setNeedsLayout()
		}

		cell.titleLabel.text = title
		cell.contentView.backgroundColor = cellBackgroundColor
		cell.titleLabel.textColor = cellTextColor
		cell.animateAppearance(indexPath.row)
		return cell
	}
	
	override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
		let item = items[indexPath.row]
		delegate?.didSelectItem(item)
	}
	
	override func collectionView(collectionView: UICollectionView, didHighlightItemAtIndexPath indexPath: NSIndexPath) {
		let cell = collectionView.cellForItemAtIndexPath(indexPath) as! BoomSectionCollectionViewCell
		cell.animatePress()
	}
	
	override func collectionView(collectionView: UICollectionView, didUnhighlightItemAtIndexPath indexPath: NSIndexPath) {
		let cell = collectionView.cellForItemAtIndexPath(indexPath) as! BoomSectionCollectionViewCell
		cell.animateUnpress()
		
	}
}