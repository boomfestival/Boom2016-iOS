//
//  BoomMenuCollectionViewCell.swift
//  Boom
//
//  Created by Florin Braghis on 11/3/15.
//  Copyright © 2015 CodeShaman. All rights reserved.
//

import UIKit

class BoomCellWithImageView : UICollectionViewCell {
	let imageView = UIImageView()
	override init(frame: CGRect) {
		super.init(frame: frame)
		addSubview(imageView)
		imageView.snp_makeConstraints { (make) -> Void in
			make.edges.equalTo(self.contentView)
		}
	}

	required init?(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}
}

class BoomMenuCollectionViewCell : UICollectionViewCell {
	
	let titleLabel = UILabel()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		titleLabel.font = Appearance.Font.polygraphBold(30)
		titleLabel.textAlignment = .Center
		contentView.addSubview(titleLabel)
		
		titleLabel.snp_makeConstraints { (make) -> Void in
			make.left.equalTo(contentView)
			make.right.equalTo(contentView)
			make.centerY.equalTo(contentView)
		}
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func animateAppearance(row: Int){
		
		let delay = 0.1 * Double(row)
		self.contentView.transform = CGAffineTransformMakeScale(0, 1.0)
		
		UIView.animateWithDuration(0.5, delay: delay, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
			self.contentView.transform = CGAffineTransformIdentity
			}) { _ in
				self.contentView.transform = CGAffineTransformIdentity
		}
	}
	
	func animatePress(){
		
		UIView.animateWithDuration(0.06) { () -> Void in
			let transform = CGAffineTransformMakeTranslation(self.contentView.frame.size.width * 0.02, self.contentView.frame.size.height * 0.02)
			self.contentView.transform = transform
			self.titleLabel.textColor = UIColor.whiteColor()
		}
	}
	
	func animateUnpress(){
		UIView.animateWithDuration(0.04) { () -> Void in
			self.contentView.transform = CGAffineTransformIdentity
		}
	}
	
}


