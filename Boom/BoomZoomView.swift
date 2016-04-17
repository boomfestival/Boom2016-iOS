//
//  BoomZoomView.swift
//  ScrollViewExperimentation
//
//  Created by Florin Braghis on 10/24/15.
//  Copyright © 2015 CodeShaman. All rights reserved.
//

import UIKit

class BoomZoomView : UIView, UIScrollViewDelegate {
	var contentView: UIView!
	var scrollView: UIScrollView!
	var deviceOrientation = UIDeviceOrientation.Unknown
	
	
	convenience init(frame: CGRect, contentView: UIView) {
		self.init(frame: frame)
		
		self.scrollView = UIScrollView(frame: frame)
		
		self.contentView = contentView
		self.scrollView.addSubview(contentView)
		
		self.addSubview(scrollView)
		
		let contentSize = contentView.bounds.size
		
		assert(contentSize.width > 0 && contentSize.height > 0)
		
		scrollView.contentSize = contentSize
		scrollView.delegate = self
		scrollView.minimumZoomScale = self.bounds.width / contentSize.width
		//scrollView.minimumZoomScale = 0.259
		//assert(scrollView.minimumZoomScale > 0.0)
		scrollView.maximumZoomScale = 2.0
		scrollView.canCancelContentTouches = true
		scrollView.zoomScale = scrollView.minimumZoomScale
		
		let doubleTap = UITapGestureRecognizer(target: self, action: #selector(BoomZoomView.didDoubleTap(_:)))
		doubleTap.numberOfTapsRequired = 2
		scrollView.addGestureRecognizer(doubleTap)
		
		
		NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(BoomZoomView.didChangeOrientation), name: UIDeviceOrientationDidChangeNotification, object: nil)
	}

	func didChangeOrientation (){
		
		let deviceOrientation = UIDevice.currentDevice().orientation
		
		if (deviceOrientation == .FaceUp || deviceOrientation == .FaceDown ||
			deviceOrientation == .Unknown || deviceOrientation == self.deviceOrientation){
				return;
		}
		
		self.deviceOrientation = deviceOrientation;
		self.scrollView.zoomScale = self.scrollView.minimumZoomScale
		self.centerContentView()
	}
	
	func zoomToContentCenterMin(completion: (() -> Void)?) {
		if self.scrollView.zoomScale > self.scrollView.minimumZoomScale {
				let point = self.contentView.center
				self.scrollView.zoomWithCompletion(point, withScale: self.scrollView.minimumZoomScale, animationDuration: 0.55, completion: completion)
		}
	}
	
	func zoomToPoint(pt: CGPoint, scale: CGFloat, completion: (() -> Void)?) {
		var point = pt
		
		if (scrollView.zoomScale == scrollView.minimumZoomScale){
			//Adjust for center
			point.x -= self.contentView.frame.origin.x
			point.y -= self.contentView.frame.origin.y
		}

		NSLog("zoomToPoint: point = \(point), scale = \(scale)")
		self.scrollView.zoomWithCompletion(point, withScale: scale, animationDuration: 0.55, completion: completion)
	}
	
	func didDoubleTap(sender: UITapGestureRecognizer) {
		
		if sender.state == .Ended {
			
			if scrollView.zoomScale > scrollView.minimumZoomScale {
				self.zoomToContentCenterMin(nil)
			}
			else {
				let point = sender.locationInView(self.scrollView)
				self.zoomToPoint(point, scale: CGFloat(1.0), completion: nil)
			}
		}
	}
	
	func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
		return self.contentView
	}
	
	func centerContentView(){
		NSLog("centerContentView()")
		if let subView = contentView {
			let offsetX = max(0.0, (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5)
			let offsetY = max(0.0, (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5)
			subView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX, scrollView.contentSize.height * 0.5 + offsetY)
		}
	}
	
	func scrollViewDidZoom(scrollView: UIScrollView) {
		
		//NSLog("scrollViewDidZoom. zoomScale = \(self.scrollView.zoomScale)")
		
		if (self.scrollView.zoomScale == self.scrollView.minimumZoomScale){
			//Center the subview
			centerContentView()
		}
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		scrollView.frame = self.bounds
	}
}
