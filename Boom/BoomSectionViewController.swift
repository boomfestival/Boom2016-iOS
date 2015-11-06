//
//  BoomListView.swift
//  Boom
//
//  Created by Florin Braghis on 10/17/15.
//  Copyright © 2015 CodeShaman. All rights reserved.
//

import UIKit

class BoomSectionViewController : BoomViewController, BoomSectionDelegate {
	var collectionView: BoomListCollectionViewController!
	var flowLayout: UICollectionViewFlowLayout!
	var section: SectionEntry
	init(section: SectionEntry){
		self.section = section
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		BoomSectionCollectionViewCell.nextAppearanceTransform()
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		flowLayout = UICollectionViewFlowLayout()
		flowLayout.scrollDirection = .Vertical
		flowLayout.itemSize = CGSizeMake(300, 150)
				
		collectionView = BoomListCollectionViewController(collectionViewLayout: flowLayout)
		collectionView.items = section.links
		collectionView.cellBackgroundColor = sectionColor
		collectionView.cellTextColor = sectionTextColor
		collectionView.collectionView?.contentInset = UIEdgeInsets(top: 70, left: 10, bottom: 0, right: 10)
		collectionView.delegate = self
		
		view.addSubview(collectionView.view)
		
		collectionView.view.snp_makeConstraints { (make) -> Void in
			make.edges.equalTo(self.view)
		}
		
		setTitleText(self.title ?? "")
	}
	
	func didSelectItem(item: SectionItem) {
		UIViewController.viewControllerForKey(item.href) { viewController in
			if let viewController = viewController as? BoomViewController {
				viewController.sectionColor = self.sectionColor
				viewController.title = item.title
				viewController.sectionTextColor = self.sectionTextColor
				self.navigationController?.pushViewController(viewController, animated: true)
			}
		}
	}
	

	
}