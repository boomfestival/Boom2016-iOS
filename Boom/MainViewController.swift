//
//  TestViewController.swift
//  Boom
//
//  Created by Florin Braghis on 10/16/15.
//  Copyright © 2015 CodeShaman. All rights reserved.
//

import UIKit

class BoomEffects {
	
	static weak var circlesView: BoomSpinView?
	
	static func pauseMainAnimation(){
		circlesView?.animateRotation(0)
	}
	static func resumeMainAnimation(){
		circlesView?.animateRotation(0.1)
	}
}

class MainViewController : UIViewController, UINavigationControllerDelegate, BoomMenuViewControllerDelegate, BoomZoomViewDelegate {
	var circlesView: BoomSpinView!
	var zoomView: BoomZoomView!
	let contentNavigationController = BoomNavigationController()


	override func viewDidLoad() {
		super.viewDidLoad()
		self.view.backgroundColor = UIColor.blackColor()
		self.setupView()

		let menuVC = BoomMenuViewController()
		
		menuVC.delegate = self
		self.addContentNavigationController()
		self.contentNavigationController.pushViewController(menuVC, animated: true)
		Model.updateIfNecessary(nil)
	}
	
	func addContentNavigationController() {
		contentNavigationController.delegate = self
		self.addChildViewController(contentNavigationController)
		self.view.addSubview(contentNavigationController.view)
		contentNavigationController.view.snp_remakeConstraints { (make) -> Void in
			make.edges.equalTo(self.view)
		}
		
		let frame = self.view.bounds
		
		UIView.animateWithDuration(0.5) { _ in
			self.contentNavigationController.view.alpha = 1.0
			self.contentNavigationController.view.frame = frame
		}
	}
	
	func didTapOutsideOfMenu() {
	
		var frame = self.view.bounds
		frame.origin.y -= frame.height
		//Remove it
		UIView.animateWithDuration(0.5, animations: { _ in
			self.contentNavigationController.view.alpha = 0.0
			self.contentNavigationController.view.frame = frame
			
		}) { _ in
			self.contentNavigationController.removeFromParentViewController()
			self.contentNavigationController.view.removeFromSuperview()
		}
	}
	
	func boomZoomDidZoomToMinScale(boomZoom: BoomZoomView) {
		if boomZoom == self.zoomView {
			self.addContentNavigationController()
		}
	}
	
	func setupView() {
		self.view.backgroundColor = UIColor.blackColor()
		
		circlesView = BoomSpinView()
		
		var contentSize = circlesView.contentSize()
		
		//Reduce content size to get rid of the black areas in the background view
		contentSize.width -= 200
		contentSize.height -= 200

		circlesView.frame = CGRectMake(0, 0, contentSize.width, contentSize.height)
		zoomView = BoomZoomView(frame: self.view.bounds, contentView: circlesView)
		self.view.insertSubview(zoomView, atIndex: 0)
		circlesView.animateRotation(0.1)
		
		zoomView.snp_makeConstraints { (make) -> Void in
			make.edges.equalTo(self.view)
		}
		
		zoomView.delegate = self
		
		BoomEffects.circlesView = circlesView
	}
	
	
	func zoomToRandomPoint(){
		let frame = self.zoomView.scrollView.frame
		
		
		let x = CGFloat(arc4random_uniform(UInt32(frame.size.width)))
		let y = CGFloat(arc4random_uniform(UInt32(frame.size.height)))
		
		//contentSize.width = Int(arc4random_uniform(Int(contentSize.width)))
		self.zoomView.zoomToPoint(CGPoint(x: x, y: y), scale: 1.0)
		//self.zoomView.zoomThroughCenter(CGPoint(x: x, y: y), scale: 1.0, duration: 2.0)
	}

	
	func navigationController(navigationController: UINavigationController, willShowViewController viewController: UIViewController, animated: Bool) {
		if viewController is BoomMenuViewController {
			navigationController.navigationBarHidden = true
			self.zoomView.zoomToContentCenterMin()
		} else {
			navigationController.navigationBarHidden = false
			self.zoomToRandomPoint()
		}
	}
}