//
//  BoomAudioPlayerContainer.swift
//  Boom
//
//  Created by Florin Braghis on 11/6/15.
//  Copyright © 2015 CodeShaman. All rights reserved.
//

import UIKit

//Display the audio controls on top of the content view
class BoomAudioPlayerContainer : UIView {
	var audioControls: UIView!
	var contentView: UIView!
	
	convenience init(frame: CGRect, audioControls: UIView, contentView: UIView) {
		
		self.init(frame: frame)
		
		self.audioControls = audioControls
		self.contentView = contentView
		
		addSubview(contentView)
		contentView.snp_makeConstraints { (make) -> Void in
			make.edges.equalTo(self)
		}
		
		addSubview(audioControls)
		
		audioControls.snp_makeConstraints { (make) -> Void in
			make.bottom.equalTo(self)
			make.left.right.equalTo(self)
			make.height.equalTo(40)
		}
	}
}
