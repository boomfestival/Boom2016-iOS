//
//  UIScrollView+Ext.swift
//  ScrollViewExperimentation
//
//  Created by Florin Braghis on 10/24/15.
//  Copyright © 2015 CodeShaman. All rights reserved.
//

import UIKit


extension UIScrollView {
	
	func zoomWithCompletion(zoomPoint: CGPoint, withScale: (CGFloat), animationDuration: Double, completion: (()->Void)?){
		NSLog("Zooming to: \(zoomPoint) withScale: \(withScale)")
		//Ensure scale is clamped to the scroll view's allowed zooming range
		var scale = withScale
		scale = min(scale, self.maximumZoomScale)
		scale = max(scale, self.minimumZoomScale)
		
		let animated = animationDuration > 0.0
		
		//`zoomToRect` works on the assumption that the input frame is in relation
		//to the content view when zoomScale is 1.0
		
		//Work out in the current zoomScale, where on the contentView we are zooming
		
		var translatedPoint = CGPointZero
		translatedPoint.x = zoomPoint.x + self.contentOffset.x
		translatedPoint.y = zoomPoint.y + self.contentOffset.y
		
		let zoomFactor = CGFloat(1.0) / self.zoomScale
		
		translatedPoint.x *= zoomFactor
		translatedPoint.y *= zoomFactor
		
		//work out the size of the rect to zoom to, and place it with the zoom point in the middle
		
		
		var destinationRect = CGRectZero
		
		destinationRect.size.width = CGRectGetWidth(self.frame) / scale
		destinationRect.size.height = CGRectGetHeight(self.frame) / scale
		destinationRect.origin.x = translatedPoint.x - CGRectGetWidth(destinationRect) * 0.5
		destinationRect.origin.y = translatedPoint.y - CGRectGetHeight(destinationRect) * 0.5
		
		if animated {
			UIView.animateWithDuration(animationDuration, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.6, options: .AllowUserInteraction, animations: { () -> Void in
				self.zoomToRect(destinationRect, animated: false)
				}, completion: { (completed) -> Void in
					if let viewForZoom = self.delegate?.viewForZoomingInScrollView?(self) {
						self.delegate?.scrollViewDidEndZooming?(self, withView: viewForZoom, atScale: scale)
					}
					completion?()
			})
		}

	}
}
