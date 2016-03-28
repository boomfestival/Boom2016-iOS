//
//  BoomMenuView.swift
//  Boom
//
//  Created by Florin Braghis on 10/16/15.
//  Copyright © 2015 CodeShaman. All rights reserved.
//

import UIKit

protocol BoomMenuViewControllerDelegate : BoomMenuDelegate {
	func didTapOutsideOfMenu()
}

class BoomMenuViewController : UIViewController {
	var menuView: BoomMenuView!
	var menuItemsCollectionView: BoomMenuCollectionViewController!
	var delegate: BoomMenuViewControllerDelegate?
	var menuItems: [MenuItem] {
		get {
			let whiteColor = UInt(0xffffff)
			let black = UInt(0)
			return [
				MenuItem("NEWS", 0xff3100, whiteColor),
				MenuItem("ENVIRONMENT", 0x468b10, whiteColor),
				MenuItem("PROGRAM", 0xfe581a, whiteColor),
				MenuItem("BOOMGUIDE", 0x0993f4, whiteColor),
				MenuItem("GALLERY", 0xa25afb, whiteColor),
				MenuItem("PARTICIPATE", 0xff49ac, whiteColor),
				MenuItem("TICKETS", 0xffda00, black)
				//MenuItem("RADIO", 0x13c0f4)
			]
		}
	}
	override func viewDidLoad() {
		super.viewDidLoad()

		assert(self.delegate != nil)
		
		//Collection view
		let flowLayout = UICollectionViewFlowLayout()
		flowLayout.scrollDirection = .Vertical
		menuItemsCollectionView = BoomMenuCollectionViewController(collectionViewLayout: flowLayout)
		menuItemsCollectionView.delegate = self.delegate
		menuItemsCollectionView.menuItems = menuItems

		//Decorator
		menuView = BoomMenuView(frame: view.bounds, contentView: menuItemsCollectionView.view)
		view.addSubview(menuView)
		
		menuView.snp_makeConstraints { (make) -> Void in
			make.centerX.equalTo(self.view)
			make.top.equalTo(self.view)
			make.bottom.equalTo(self.view)
			make.width.equalTo(250)
		}
		let tap = UITapGestureRecognizer(target: self, action: #selector(BoomMenuViewController.didTap(_:)))
		tap.cancelsTouchesInView = false
		view.addGestureRecognizer(tap)
	}
	
	func didTap(sender: UITapGestureRecognizer){
		if sender.state == .Ended {
			let didTapOutsideOfMenu = !CGRectContainsPoint(menuView.bounds, sender.locationInView(menuView))
			if didTapOutsideOfMenu {
				delegate?.didTapOutsideOfMenu()
				return
			}
		}
	}
}