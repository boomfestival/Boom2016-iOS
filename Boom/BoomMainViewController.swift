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


class BoomMainViewController : UIViewController, UINavigationControllerDelegate, BoomMenuViewControllerDelegate, BoomZoomViewDelegate {
	var meditatingView: BoomMeditatingView!
	let contentNavigationController = BoomNavigationController()
	var audioPlayerViewController : AudioPlayerViewController!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		meditatingView = BoomMeditatingView(frame: view.bounds, contentView: contentNavigationController.view)
		meditatingView.zoomView.delegate = self


		audioPlayerViewController = AudioPlayerViewController()
		let subView = BoomAudioPlayerContainer(frame: self.view.bounds, audioControls: audioPlayerViewController.view, contentView: meditatingView)

		//let subView = meditatingView
		view.addSubview(subView)
		
		subView.snp_makeConstraints { (make) -> Void in
			make.edges.equalTo(self.view)
		}
		setupContentNavigationController()
		Model.updateIfNecessary(nil)
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
		contentNavigationController.pushViewController(menuViewController, animated: false)
	}
	
	func didTapOutsideOfMenu() {
		meditatingView.toggleRotation()
	}
	
	func didTapMenuLogo() {
		meditatingView.minimizeContentView(nil)
	}
	
	func boomZoomDidZoomToMinScale(boomZoom: BoomZoomView) {
		meditatingView.showContentView()
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
		
		meditatingView.minimizeContentView() {

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