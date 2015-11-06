//
//  UIColor+Extra.swift
//  Boom
//
//  Created by Florin Braghis on 10/16/15.
//  Copyright © 2015 CodeShaman. All rights reserved.
//

import UIKit

extension UIColor {
	convenience init(rgbValue: UInt) {
		self.init(
			red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
			green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
			blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
			alpha: CGFloat(1.0)
		)
	}
}

extension UIImage {
	static public func imageWithColor(color: UIColor) -> UIImage {
		let rect = CGRect(origin: CGPoint.zero, size: CGSize(width: 1.0, height: 1.0))
		UIGraphicsBeginImageContext(rect.size)
		let context = UIGraphicsGetCurrentContext()
		CGContextSetFillColorWithColor(context, color.CGColor)
		CGContextFillRect(context, rect)
		let image = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		return image
	}
}