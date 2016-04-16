//
//  BoomMeditatingView.swift
//  Boom
//
//  Created by Florin Braghis on 11/3/15.
//  Copyright © 2015 CodeShaman. All rights reserved.
//

import UIKit
import SnapKit

class BoomMeditatingView : UIView {
	var circlesView: BoomSpinView!
	var zoomView: BoomZoomView!
	var contentView: UIView!
	
	required convenience init(frame: CGRect, contentView: UIView){
		self.init(frame: frame)
		self.contentView = contentView
		setupView()
	}
	
	func setupView(){
		backgroundColor = UIColor.blackColor()
		setupMeditationView()
		setupContentView()
	}
	
	func setupMeditationView() {
		circlesView = BoomSpinView()
		var contentSize = circlesView.contentSize()
		
		//Reduce content size to get rid of the black areas in the background view
		contentSize.width -= 200
		contentSize.height -= 200
		
		circlesView.frame = CGRectMake(0, 0, contentSize.width, contentSize.height)
		circlesView.animateRotation(0.1)
		
		zoomView = BoomZoomView(frame: self.bounds, contentView: circlesView)
		insertSubview(zoomView, atIndex: 0)
		zoomView.snp_makeConstraints { (make) -> Void in
			make.edges.equalTo(self)
		}
		
		//Set up the delegate in the view controller
		//		zoomView.delegate = self
	}
	
	func setupContentView() {
		addSubview(contentView)
		contentView.snp_remakeConstraints { (make) -> Void in
			make.edges.equalTo(self)
		}
		showContentView()
	}
	
	func showContentView() {
		contentView.hidden = false
        animateContentView(CGAffineTransformIdentity, nil)
	}

	func maximizeContentView(completion: (() -> Void)?){
		animateContentView(CGAffineTransformMakeScale(10.0, 10.0), completion)
	}
	
    func minimizeContentView(push: Bool, completion: (() -> Void)?) {
		//let height = self.contentView!.frame.size.height
        var width = self.contentView!.frame.size.width
        if push { width = -width }
        
		animateContentView(CGAffineTransformMakeTranslation(width, 0), completion)
	}
	
	func restoreContentView(completion: (() -> Void)?) {
		animateContentView(CGAffineTransformIdentity, completion)
	}
	
	private func animateContentView(transform: CGAffineTransform, _ completion: (() -> Void)?) {

		UIView.animateWithDuration(0.2,
			delay: 0,
			options: UIViewAnimationOptions.CurveEaseOut,
			animations: {
				self.contentView.transform = transform
			},
			completion: { _ in
				completion?()
		})
	}
	
	
	func zoomToRandomPoint(completion: (() -> Void)?){
		let center = self.circlesView.center
		let r = 560.0
		let num = Double(arc4random_uniform(9))
		let x = Double(center.x) + r * cos( M_PI_4 * num )
		let y = Double(center.y) + r * sin( M_PI_4 * num )
		self.zoomView.zoomToPoint(CGPoint(x: x, y: y), scale: 1.0, completion: completion)
	}
	
	func toggleRotation() {
		circlesView.toggleRotation()
	}
}
