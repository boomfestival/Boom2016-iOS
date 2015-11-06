//
//  BoomNavigationController.swift
//  Boom
//
//  Created by Florin Braghis on 10/17/15.
//  Copyright © 2015 CodeShaman. All rights reserved.
//

import UIKit

class BoomNavigationController : UINavigationController{
	override func viewDidLoad() {
		super.viewDidLoad()
		
		let backgroundImage = UIImage.imageWithColor(UIColor(red: 0, green: 0, blue: 0, alpha: 0.7))
		self.navigationBar.setBackgroundImage(backgroundImage, forBarMetrics: .Default)
		self.navigationBar.translucent = true
		self.navigationBar.tintColor = UIColor.whiteColor()

		let arrow = UIImage(named: "navigation_back")!
		let arrowMask = UIImage(named: "navigation_back_mask")!
		
		UINavigationBar.appearance().backIndicatorImage = arrow
		UINavigationBar.appearance().backIndicatorTransitionMaskImage = arrowMask

	
	}
}
