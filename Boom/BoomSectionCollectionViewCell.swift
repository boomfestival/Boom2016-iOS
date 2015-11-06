//
//  BoomSectionCells.swift
//  Boom
//
//  Created by Florin Braghis on 11/3/15.
//  Copyright © 2015 CodeShaman. All rights reserved.
//

import UIKit

class BoomRoundedImageView : UIView {
	let imageView = UIImageView()
	var imgMaskLayer = CAShapeLayer()
	
	convenience init(){
		self.init(frame: CGRectZero)
		addSubview(imageView)
		imageView.layer.mask = imgMaskLayer
		imageView.layer.shouldRasterize = true
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		imageView.frame = bounds
		imgMaskLayer.path = UIBezierPath(roundedRect: imageView.bounds, byRoundingCorners: .BottomLeft, cornerRadii: CGSizeMake(20, 20)).CGPath
	}
}

class BoomSectionCollectionViewCell : UICollectionViewCell{
	let titleLabel = UILabel()
	let roundedImageView = BoomRoundedImageView()
	private static var appearanceTransformId = 0
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		titleLabel.font = Appearance.Font.polygraphBold(20)
		titleLabel.textAlignment = .Left
		titleLabel.backgroundColor = UIColor.clearColor()
		titleLabel.textColor = UIColor.whiteColor()
		contentView.addSubview(titleLabel)
		
		titleLabel.snp_makeConstraints { (make) -> Void in
			make.left.equalTo(contentView).offset(15)
			make.right.equalTo(contentView)
			make.bottom.equalTo(contentView).offset(-2)
			make.height.equalTo(25)
		}
		
		contentView.addSubview(roundedImageView)
		
		roundedImageView.snp_makeConstraints { (make) -> Void in
			make.left.equalTo(self.contentView).offset(2)
			make.top.equalTo(self.contentView).offset(2)
			make.right.equalTo(self.contentView).offset(-2)
			make.bottom.equalTo(titleLabel.snp_top)
		}
		
		layer.shadowColor = UIColor.blackColor().CGColor
		layer.shadowOffset = CGSizeMake(0, 5.0)
		layer.shadowRadius = 4.0
		layer.shadowOpacity = 0.9
		layer.masksToBounds = false
	}
	//TODO: This could be moved to a separate class ?
	static func nextAppearanceTransform(){
		BoomSectionCollectionViewCell.appearanceTransformId = (BoomSectionCollectionViewCell.appearanceTransformId + 1) % 4
		NSLog("BoomSectionCollectionViewCell.nextAppearanceTransform: \(BoomSectionCollectionViewCell.appearanceTransformId)")

	}
	
	func transformWithId(id: Int) -> CGAffineTransform {
		var transform = CGAffineTransformMakeScale(0.01, 0.01)
		
		switch (id) {
		case 0:
			let rotation = CGAffineTransformMakeRotation(CGFloat(M_PI * 2))
			let scale = CGAffineTransformMakeScale(0.0, 1.0)
			transform = CGAffineTransformConcat(rotation, scale)
		case 1:
			transform = CGAffineTransformMakeScale(0.01, 0.01)
		case 2:
			transform = CGAffineTransformMakeScale(0.0, 1.0)
		case 3:
			transform = CGAffineTransformMakeScale(1.0, 0.0)
		default:
			break
		}
		
		return transform
	}
	
	func animateAppearance(row: Int){
		
		let delay = 0.06 * Double(row)
		contentView.transform = self.transformWithId(BoomSectionCollectionViewCell.appearanceTransformId)
		
		UIView.animateWithDuration(0.7, delay: delay, usingSpringWithDamping: 0.70, initialSpringVelocity: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
			self.contentView.transform = CGAffineTransformIdentity
			}, completion: nil)
		
	}
	
	func animatePress(){
		UIView.animateWithDuration(0.06) {
			let transform = CGAffineTransformMakeTranslation(self.contentView.frame.size.width * 0.02, self.contentView.frame.size.height * 0.02)
			self.contentView.transform = transform
			self.contentView.layer.shadowRadius = 0;
			self.layer.shadowOffset = CGSizeMake(0, 0.0)
			
		}
	}
	
	func animateUnpress(){
		UIView.animateWithDuration(0.04) {
			self.contentView.transform = CGAffineTransformIdentity
			self.contentView.layer.shadowRadius = 4.0
			self.layer.shadowOffset = CGSizeMake(0, 5.0)
		}
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}

