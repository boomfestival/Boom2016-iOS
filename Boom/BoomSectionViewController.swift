//
//  BoomListView.swift
//  Boom
//
//  Created by Florin Braghis on 10/17/15.
//  Copyright © 2015 CodeShaman. All rights reserved.
//

import UIKit
import Realm

class BoomSectionViewController : BoomViewController, BoomSectionDelegate {
	var collectionView: BoomListCollectionViewController!
    
    //called after the key has been changed
    override func entryDidChange()
    {
        guard let section = self.entry as? SectionEntry else
        {
            NSLog("New entry not a section entry", self.entryKey)
            return
        }
        
        if (isViewLoaded())
        {
            NSLog("SectionViewController: Reloading collection view items")
            collectionView.items = section.links
            collectionView.collectionView?.reloadData()
        }
    }

	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		BoomSectionCollectionViewCell.nextAppearanceTransform()
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()


        setupCollectionView()
		setTitleText(self.title ?? "")
        
        guard let section = self.entry as? SectionEntry else
        {
            return
        }

        collectionView.items = section.links
	}
    
    func setupCollectionView()
    {
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .Vertical
        flowLayout.itemSize = CGSizeMake(300, 150)
        
        collectionView = BoomListCollectionViewController(collectionViewLayout: flowLayout)
        collectionView.cellBackgroundColor = sectionColor
        collectionView.cellTextColor = sectionTextColor
        collectionView.collectionView?.contentInset = UIEdgeInsets(top: 70, left: 10, bottom: 0, right: 10)
        collectionView.delegate = self
        
        view.addSubview(collectionView.view)
        
        collectionView.view.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(self.view)
        }
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