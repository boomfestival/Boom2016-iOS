//
//  BoomMainViewController.swift
//  Boom
//
//  Created by Florin Braghis on 10/16/15.
//  Copyright © 2015 CodeShaman. All rights reserved.
//
//	Refactoring to reduce the usage of self.
//	That means less self or less ego :) in the code

import UIKit
import SnapKit
import AVFoundation


class BoomMainViewController : UIViewController, UINavigationControllerDelegate, BoomMenuViewControllerDelegate {
	var meditatingView: BoomMeditatingView!
	let contentNavigationController = BoomNavigationController()
    var emptyViewController: UIViewController!
	
	override func viewDidLoad() {
		super.viewDidLoad()
        setupMeditatingView()
		setupContentNavigationController()
		Model.updateIfNecessary(nil)
	}
    
    func setupMeditatingView()
    {
        meditatingView = BoomMeditatingView(frame: view.bounds, contentView: contentNavigationController.view)
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(didSwipeMeditatingView(_:)))
        swipe.direction = UISwipeGestureRecognizerDirection.Left
        meditatingView.addGestureRecognizer(swipe)
        meditatingView.circlesView.onTapSunAndMoon(self, action: #selector(didTapSunAndMoon(_:)))

        view.addSubview(meditatingView)
        
        meditatingView.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(self.view)
        }
    }
    
    func setupContentNavigationController() {
        contentNavigationController.delegate = self
        addChildViewController(contentNavigationController)
        pushMenuViewController()
    }

	func pushMenuViewController() {
        let menuViewController = BoomMenuViewController()
		menuViewController.delegate = self
		menuViewController.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
		contentNavigationController.pushViewController(menuViewController, animated: true)

        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(didSwipeMenuView(_:)))
        swipe.direction = UISwipeGestureRecognizerDirection.Right
        
        menuViewController.view .addGestureRecognizer(swipe)
	}
    

    //Actions
    
    func didTapSunAndMoon(sender: UITapGestureRecognizer)
    {
        meditatingView.showContentView()
    }
    
    func didSwipeMenuView(sender: UISwipeGestureRecognizer)
    {
        meditatingView.minimizeContentView(false, completion:nil)
    }

    func didSwipeMeditatingView(sender: UISwipeGestureRecognizer)
    {
        meditatingView.showContentView()
    }

	func didTapOutsideOfMenu() {
		meditatingView.toggleRotation()
	}
	
	func didTapMenuLogo() {
        showAbout()
	}
		
	func navigationController(navigationController: UINavigationController, willShowViewController viewController: UIViewController, animated: Bool) {
		if viewController is BoomMenuViewController {
			navigationController.navigationBarHidden = true
			meditatingView.zoomView.zoomToContentCenterMin() {
				self.meditatingView.contentView.transform = CGAffineTransformIdentity
			}
		} else {
			navigationController.navigationBarHidden = false
			//meditatingView.zoomToRandomPoint()
		}
	}
	
	func didSelectMenuItem(menuItem: MenuItem) {
		let key = menuItem.title.lowercaseString
		
		meditatingView.minimizeContentView(true) {

			self.meditatingView.zoomToRandomPoint() {
				self.meditatingView.contentView.transform = CGAffineTransformIdentity
				UIViewController.viewControllerForKey(key) { [weak self] viewController in
					if let viewController = viewController as? BoomViewController {
						viewController.sectionColor = menuItem.sectionColor
						viewController.title = menuItem.title
						viewController.sectionTextColor = menuItem.textColor
						self?.contentNavigationController.pushViewController(viewController, animated: false)
						self?.meditatingView.hidden = false
						self?.meditatingView.restoreContentView(nil)
					}
				}
			}
		}
	}
}