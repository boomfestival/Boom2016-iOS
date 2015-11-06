//
//  Appearance.swift
//  Boom
//
//  Created by Florin Braghis on 10/20/15.
//  Copyright © 2015 CodeShaman. All rights reserved.
//


import UIKit

class Appearance{
	
	struct Font {
		
		static func polygraphBold(size: CGFloat) -> UIFont {
			return UIFont(name: "Polygraph-Bold", size: size)!
		}

		static func polygraph(size: CGFloat) -> UIFont {
			return UIFont(name: "Polygraph", size: size)!
		}
		
	}
}

extension UIViewController {
	
	func setTitleText(text: String) {
		let titleLabel = UILabel()
		titleLabel.textColor = UIColor.whiteColor()
		titleLabel.font = Appearance.Font.polygraphBold(25)
		let unescaped = String(htmlEncodedString: text)
		let strText = unescaped.characters.count > 0 ? unescaped : "BOOM FESTIVAL 2016 - 11TH EDITION"
		titleLabel.text = strText
		titleLabel.textAlignment = .Center
		titleLabel.sizeToFit()
		self.navigationItem.titleView = titleLabel
		self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
	}
}