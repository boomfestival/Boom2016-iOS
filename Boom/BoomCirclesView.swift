//
//  BoomCirclesView.swift
//  ScrollViewExperimentation
//
//  Created by Florin Braghis on 10/24/15.
//  Copyright © 2015 CodeShaman. All rights reserved.
//

import UIKit


class RotatingDiscsView : UIView {
	var imageViews: [UIImageView]!
	
	convenience init(frame: CGRect, imageNames: [String]){
		self.init(frame: frame)
		
		imageViews = imageNames.map { name in
			let imageView = UIImageView()
			imageView.contentMode = .ScaleAspectFit
			imageView.image = UIImage(named: name)
			imageView.sizeToFit()
			imageView.userInteractionEnabled = true
			return imageView
		}
		
		for imageView in imageViews {
			self.addSubview(imageView)
		}
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		for imageView in imageViews {
			imageView.center = self.center
		}
	}
	
	func stopSpinning(imageIndex: Int){
		let view = self.imageViews[imageIndex]
		
		if let presentationLayer = view.layer.presentationLayer() {
			view.layer.transform = presentationLayer.transform
		}
		view.layer.removeAnimationForKey("rotationAnimation")
	}
	
	func spinClockwise(imageIndex: Int, duration: CGFloat){
		self.spin(imageIndex, duration: duration, direction: 1.0)
	}
	
	func spinCounterClockwise(imageIndex: Int, duration: CGFloat) {
		self.spin(imageIndex, duration: duration, direction:  -1.0)
	}
	
	func spin(imageIndex: Int, duration: CGFloat, direction: (Double) = 1.0){
		
		stopSpinning(imageIndex)

		if duration > 0 {
			let view = self.imageViews[imageIndex]
			let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
			
			rotationAnimation.toValue = M_PI * 2.0 * direction
			rotationAnimation.duration = Double(duration)
			rotationAnimation.cumulative = true
			rotationAnimation.repeatCount = Float.infinity
			rotationAnimation.fillMode = kCAFillModeForwards
			rotationAnimation.removedOnCompletion = false
			rotationAnimation.timingFunction = nil

			view.layer.addAnimation(rotationAnimation, forKey: "rotationAnimation")
		}
	}
	
}

class BoomSpinView : UIView {
	
	var discs: RotatingDiscsView!
	var isRotating = false
	var lastRotationSpeed:CGFloat = 0.1
	
	convenience init(){
		self.init(frame: CGRectZero)
		
		let imageNames = ["background-layer", "circle-layer", "shamans-layer", "dragons-layer", "sun-moon-layer"]
		
		self.discs = RotatingDiscsView(frame: self.bounds, imageNames: imageNames)
		self.addSubview(discs)
		
		if let lastImage = self.discs.imageViews.last {
			let singleTap = UITapGestureRecognizer(target: self, action: "didTapSunMoon:")
			singleTap.numberOfTapsRequired = 1
			lastImage.addGestureRecognizer(singleTap)
		}
	}
	
	func contentSize() -> CGSize {
		//return the 'circle-layer' size as the 'content size'
		let backImage = self.discs.imageViews[1].image
		let size = backImage?.size ?? CGSizeMake(0,0)
		return size
	}
	
	func didTapSunMoon(sender: UITapGestureRecognizer){
		self.toggleRotation()
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		self.discs.frame = self.bounds
	}
	
	func toggleRotation(){
		if isRotating {
			self.stopRotation()
		}
		else {
			self.animateRotation(lastRotationSpeed)
		}
	}
	
	func stopRotation(){
		self.animateRotation(0)
	}
	
	func animateRotation(speed: CGFloat){

		if speed > 0 {
			lastRotationSpeed = speed
		}
		
		let factor = speed > 0 ? 1 / speed : 0
		
		isRotating = factor > 0
		
		self.discs.spin(0, duration: 6 * factor)
		self.discs.spin(1, duration: 5 * factor, direction: -1)
		self.discs.spin(2, duration: 4 * factor)
		self.discs.spin(3, duration: 3 * factor, direction: -1)
		self.discs.spin(4, duration: 3 * factor)
	}
}
