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
    var section: SectionEntry!
    var realmNotification: RLMNotificationToken? = nil
    
    override func viewDidLoad() {
		super.viewDidLoad()

        realmNotification = Model.realm!.addNotificationBlock { [weak self] _ in
            self?.reloadFromDatabase()
        }

        setupCollectionView()
		setTitleText(self.title ?? "")
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

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        BoomSectionCollectionViewCell.nextAppearanceTransform()
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
	
    //called after the key has been changed
    func reloadFromDatabase()
    {
        guard let res = Entry.entryWithKey(Model.realm, key: self.entryKey) as? SectionEntry else
        {
            print("Entry is not available", self.entryKey)
            self.dismissViewControllerAnimated(true, completion: nil)
            return
        }
        
        self.section = res
        
        if (isViewLoaded())
        {
            NSLog("SectionViewController: Reloading collection view items")
            collectionView.items = section.links
            collectionView.collectionView?.reloadData()
        }
    }
    
    deinit
    {
        NSLog("Deinit BoomSectionViewController")
        realmNotification?.stop()
    }
}