//
//  BoomMenuView.swift
//  Boom
//
//  Created by Florin Braghis on 11/3/15.
//  Copyright © 2015 CodeShaman. All rights reserved.
//

import UIKit

class BoomMenuView : UIView {
	let backgroundView = UIView()
	
	convenience init(frame: CGRect, contentView: UIView) {
		self.init(frame: frame)
		backgroundColor = UIColor.clearColor()
		
		//Background
		addSubview(backgroundView)
		backgroundView.backgroundColor = UIColor.blackColor()
		backgroundView.layer.opacity = 0.7
		
		backgroundView.snp_makeConstraints { (make) -> Void in
			make.edges.equalTo(self)
		}

		addSubview(contentView)
		
		contentView.snp_makeConstraints { (make) -> Void in
			make.top.equalTo(self)
			make.left.equalTo(self)
			make.right.equalTo(self)
			make.bottom.equalTo(self)
		}
	}
}
