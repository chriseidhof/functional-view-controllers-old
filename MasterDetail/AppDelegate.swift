//
//  AppDelegate.swift
//  MasterDetail
//
//  Created by Chris Eidhof on 03/09/14.
//  Copyright (c) 2014 Chris Eidhof. All rights reserved.
//

import UIKit

@UIApplicationMain



class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?


    func application(application: UIApplication!, didFinishLaunchingWithOptions launchOptions: NSDictionary!) -> Bool {
        let nc = window?.rootViewController as UINavigationController
        let combined = pushTransition(artistSelection, artistDetail)
        present(nc, myArtists, combined)
        println(nc.viewControllers)
        return true
    }
}