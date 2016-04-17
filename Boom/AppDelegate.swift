//
//  AppDelegate.swift
//  Boom
//
//  Created by Florin Braghis on 10/14/15.
//  Copyright © 2015 CodeShaman. All rights reserved.
//

import UIKit
import RealmSwift
import SwiftSpinner



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?
	var realm: Realm!


    func prepareRealm() -> Bool
    {
        guard let path = NSBundle.mainBundle().pathForResource("seed", ofType: "realm") else
        {
            return false
        }
        
        let defaultPath = Realm.Configuration.defaultConfiguration.path!
        
        do {
            NSLog("prepareRealm(): copying seed database to \(defaultPath)")

            try NSFileManager.defaultManager().copyItemAtPath(path, toPath: defaultPath)
            
        } catch {
        
            NSLog("Exception while copying database to default path: %s", defaultPath)
            return false
        }
        
        NSLog("prepareRealm(): success")
        
        return true
    }
    
	func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
		
		let defaults = NSUserDefaults.standardUserDefaults()
        
        if defaults.stringForKey("isDevMode") == "1" {
            Model.isDevMode = true
        }
		
		if defaults.boolForKey("hasBeenStartedBefore") == false {
            if prepareRealm() {
                defaults.setBool(true, forKey: "hasBeenStartedBefore")
            } else
            {
                NSLog("prepareRealm returned false. Now I don't know what to do. Maybe alert user? Ah, tequilla in my blood says: Nothing wrong will ever happen!")
                SwiftSpinner.show("Could not initialize database.", animated: false)
            }
		}
        
        self.realm = try! Realm()
        Model.realm = self.realm

		return true
	}
	


	func applicationWillResignActive(application: UIApplication) {
		// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
		// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
	}

	func applicationDidEnterBackground(application: UIApplication) {
		// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
		// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
	}

	func applicationWillEnterForeground(application: UIApplication) {
		// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
	}

	func applicationDidBecomeActive(application: UIApplication) {
		// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	}

	func applicationWillTerminate(application: UIApplication) {
		// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
	}


}

