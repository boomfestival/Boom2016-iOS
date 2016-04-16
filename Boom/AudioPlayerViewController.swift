//
//  AudioPlayerViewController.swift
//  Boom
//
//  Created by Florin Braghis on 11/2/15.
//  Copyright © 2015 CodeShaman. All rights reserved.
//

import UIKit
import Bond
import KDEAudioPlayer


class AudioPlayerViewController : UIViewController {
	var audioControls: AudioControlsView!
	var audioPlayer: AudioPlayer!
	let viewModel = AudioControlsViewModel()
	var currentItem: AudioItem?
	var hideTimer: NSTimer?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = UIColor.clearColor()
		
		audioControls = AudioControlsView(viewModel: viewModel)
		view.addSubview(audioControls)
		
		audioControls.snp_makeConstraints { (make) -> Void in
			make.edges.equalTo(self.view)
		}
		
		
		audioPlayer = AudioPlayer()
		audioPlayer.delegate = self
		currentItem = AudioItem(highQualitySoundURL: NSURL(string: "https://www.boomfestival.org/boom2016/audio/Aes_Dana_Live.mp3")!, mediumQualitySoundURL: nil, lowQualitySoundURL: nil)
		
		audioControls.playPause.addTarget(self, action: #selector(playPause), forControlEvents: .TouchUpInside)
		audioControls.slider.addTarget(self, action: #selector(scrub(_:)), forControlEvents: UIControlEvents.ValueChanged)
		
		let tapGesture = UITapGestureRecognizer(target: self, action: #selector(AudioPlayerViewController.didTouch))
		tapGesture.numberOfTapsRequired = 1
		self.view.addGestureRecognizer(tapGesture)
	}
	
	func hideSelfAfterSomeTime(){
		hideTimer?.invalidate()
		hideTimer = NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: #selector(AudioPlayerViewController.hideSelf), userInfo: nil, repeats: false)
	}
	
	func hideSelf() {
		UIView.animateWithDuration(0.5) { () -> Void in
			self.audioControls.alpha = 0.0
		}
	}
	
	func didTouch() {
		if self.audioControls.alpha == 0 {
			UIView.animateWithDuration(0.5) { () -> Void in
				self.audioControls.alpha = 1.0
				self.hideSelfAfterSomeTime()
			}
		}
	}
	
	func playPause() {
		
		if audioPlayer.state == .Playing {
			viewModel.playerState.value = .Paused
			audioPlayer.pause()
		}
		else {
			
			if (audioPlayer.currentItem == nil) {
				self.audioPlayer.playItem(currentItem!)
			} else {
				viewModel.playerState.value = .Buffering
				audioPlayer.resume()
			}
		}
		self.hideSelfAfterSomeTime()
	}
	
	func scrub(sender: UIControl?) {
		
		guard let slider = sender as? UISlider else {
			return
		}
		
		let time = Double(slider.value) * viewModel.duration.value
		audioPlayer.seekToTime(time)
		self.hideSelfAfterSomeTime()
	}
}


extension AudioPlayerViewController : AudioPlayerDelegate {
	func audioPlayer(audioPlayer: AudioPlayer, didChangeStateFrom from: AudioPlayerState, toState to: AudioPlayerState) {
		viewModel.playerState.value = to
	}
	
	func audioPlayer(audioPlayer: AudioPlayer, didFindDuration duration: NSTimeInterval, forItem item: AudioItem) {
		viewModel.duration.value = duration
	}
	
	func audioPlayer(audioPlayer: AudioPlayer, didUpdateProgressionToTime time: NSTimeInterval, percentageRead: Float) {
		viewModel.currentTime.value = time
		
	}
	
	func audioPlayer(audioPlayer: AudioPlayer, willStartPlayingItem item: AudioItem) {
		NSLog("audioPlayer will start playing item: \(item)")
	}
    func audioPlayer(audioPlayer: AudioPlayer, didUpdateEmptyMetadataOnItem item: AudioItem, withData data: Metadata) {
        
    }
    
    func audioPlayer(audioPlayer: AudioPlayer, didLoadRange range: AudioPlayer.TimeRange, forItem item: AudioItem) {
        
    }
}



