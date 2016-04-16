//
//  BoomMenuViewController+About.swift
//  Boom
//
//  Created by Florin Braghis on 4/16/16.
//  Copyright © 2016 CodeShaman. All rights reserved.
//

import Foundation
import RFAboutView_Swift


extension RFAboutViewDetailViewController
{
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        guard let contentView = self.view.subviews.first as? UITextView else
        {
            return
        }
        //A hacky way to make links clickable in the detail view
        contentView.dataDetectorTypes = UIDataDetectorTypes.Link
    }
}

extension BoomMainViewController
{
    func showAbout()
    {
        
        let aboutNav = UINavigationController()
        
        // Initialise the RFAboutView:
        
        let aboutView = RFAboutViewController(appName: nil)
        
        // Set some additional options:
        
        aboutView.headerBackgroundColor = .blackColor()
        aboutView.headerTextColor = .whiteColor()
        aboutView.blurStyle = .Dark
        
        aboutView.copyrightHolderName = "Good Mood Ltd\nDeveloped by Florin Braghis\nflorin.braghis@gmail.com"
        
        let contents = String.contentsOfTextFile("opensource")
        aboutView.addAdditionalButton("Feedback & source code", content: contents)
        
        // Add the aboutView to the NavigationController:
        aboutNav.setViewControllers([aboutView], animated: false)
        
        // Present the navigation controller:
        self.presentViewController(aboutNav, animated: true, completion: nil)
    }
}