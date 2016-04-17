//
//  BoomArticleViewController.swift
//  Boom
//
//  Created by Florin Braghis on 10/17/15.
//  Copyright © 2015 CodeShaman. All rights reserved.
//

import UIKit
import WebKit
import SwiftSpinner

class BoomArticleViewController : BoomViewController, UIWebViewDelegate {

	var webView = UIWebView()
	var article: ArticleEntry!
    var isPageLoaded = false

	override func viewDidLoad() {
		super.viewDidLoad()
		self.view.backgroundColor = UIColor.clearColor()
		self.webView.backgroundColor = UIColor.blackColor()
		self.webView.opaque = false
		webView.layer.shadowColor = UIColor.blackColor().CGColor
		webView.layer.shadowOffset = CGSizeMake(0, 5.0)
		webView.layer.shadowRadius = 4.0
		webView.layer.shadowOpacity = 0.9

		self.view.addSubview(webView)
		webView.snp_makeConstraints { make in make.edges.equalTo(self.view) }

		let url = NSBundle.mainBundle().URLForResource("html/article", withExtension: "html")
		let request = NSURLRequest(URL: url!)
		
		webView.loadRequest(request)
		
		webView.delegate = self
        
        self.setTitleText(self.article.title)
        setPageContent()

		//Uncomment if you want to be able to debug the javascript with Safari
		//self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Set", style: .Plain, target: self, action: "setPageContent")
	}
    
	func setPageContent() {
        
        guard isPageLoaded else { return }
        
		let fnCall = "setArticleTitle('\(self.article.title)')"
		webView.stringByEvaluatingJavaScriptFromString(fnCall)
		
		let imgUrl = article.getFullImageURL()
		webView.stringByEvaluatingJavaScriptFromString("setTopImage('\(imgUrl)')")
		
		if let body = article.body.escapeForJavascriptCall() {
			webView.stringByEvaluatingJavaScriptFromString("setArticleBody(\"\(body)\")")
		}
		
		webView.stringByEvaluatingJavaScriptFromString("setArticleClassNames('\(article.classNames)')")
	}
	

	
	func webViewDidFinishLoad(webView: UIWebView) {
        isPageLoaded = true
		self.setPageContent()
		//This hack gets rid of a nasty freeze of ~ 5 seconds when the page is loaded the first time
		//Could not determine the cause of that
		executeAfter(1.0) { () -> () in
			self.webView.backgroundColor = UIColor.clearColor()

		}
	}
	
	func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
		print("Error loading: \(error)")
	}
	
	func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
		if (navigationType == .LinkClicked){
			
			guard let url = request.URL, path = url.path else {
				UIApplication.sharedApplication().openURL(request.URL!)
				return false
			}
			
			let key = Entry.keyFromPath(path)

			UIViewController.viewControllerForKey(key) { [weak self] (viewController) -> Void in

				guard let viewController = viewController as? BoomViewController else {
					UIApplication.sharedApplication().openURL(request.URL!)
					return
				}
				
				self?.navigationController?.pushViewController(viewController, animated: true)
			}
			return false
		}
		return true
	}
}