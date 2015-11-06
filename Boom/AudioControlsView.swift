//
//  AudioControlsView.swift
//  Boom
//
//  Created by Florin Braghis on 11/6/15.
//  Copyright © 2015 CodeShaman. All rights reserved.
//

import UIKit
import Bond
import KDEAudioPlayer

class AudioControlsViewModel {
	
	let playerState = Observable<AudioPlayerState>(.Stopped)
	let sliderPercent = Observable(Float(0.0))
	let duration = Observable<NSTimeInterval>(0.0)
	let currentTime = Observable<NSTimeInterval>(0.0)
	init(){
		
		duration.combineLatestWith(currentTime).map { (duration, currentTime) -> Double in
			if duration > 0.0 {
				return currentTime / duration
			}
			return 0.0
			}.map { Float($0) }.bindTo(sliderPercent)
	}
}



class AudioControlsView : UIView {
	let playPause = UIButton(type: .Custom)
	let slider = UISlider()
	var viewModel: AudioControlsViewModel!
	
	required convenience init(viewModel: AudioControlsViewModel){
		self.init(frame: CGRectZero)
		self.backgroundColor = UIColor.clearColor()
		
		addSubview(playPause)
		
		playPause.snp_makeConstraints { (make) -> Void in
			make.left.equalTo(self).offset(5)
			make.centerY.equalTo(self)
		}
		
		addSubview(slider)
		slider.minimumValue = 0.0
		slider.maximumValue = 1.0
		slider.snp_makeConstraints { (make) -> Void in
			make.left.equalTo(playPause.snp_right).offset(5)
			make.right.equalTo(self).inset(50)
			make.centerY.equalTo(self)
			make.height.equalTo(self)
		}
		
		
		slider.minimumTrackTintColor = UIColor.whiteColor()
		slider.maximumTrackTintColor = UIColor.blackColor()
		
		viewModel.sliderPercent.bindTo(slider.bnd_value)
		
		viewModel.sliderPercent.observe { percent in
			//NSLog("percent = \(percent)")
		}

		viewModel.playerState.map { status -> String in
			switch status {
			case .Playing, .Buffering:
					return "icon-pause"
			default:
				break
			}
			return "icon-play"
			}.observe { [weak self] iconName in
				self?.setPlayIcon(iconName)
			}
		
//		viewModel.isPlaying.map { $0 ? "icon-pause" : "icon-play" }.observe { iconName in
//			self.playPause.setImage(UIImage(named: iconName), forState: .Normal)
//		}
		
		//For some reason the player never becomes .ReadyToPlay, even though it works, so I'm commenting this out atm
		//viewModel.playerStatus.map { $0 == .ReadyToPlay }.bindTo(playPause.bnd_enabled)
	}
	
	func setPlayIcon(imageName: String){
		playPause.setImage(UIImage(named: imageName), forState: .Normal)
	}
}

