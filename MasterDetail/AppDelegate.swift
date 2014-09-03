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
        nc.viewControllers = []
        
        let combined = pushTransition(artistSelection, artistDetail)
        present(nc, myArtists, combined)
        println(nc.viewControllers)
        return true
    }
}

func pushTransition<A,B,C>(l: VC<A,B>, r: VC<B,C>) -> VC<A,C> {
    let combined : (A, (C, UINavigationController) -> ()) -> UIViewController = {
        (from, continuation) in
        let result = l.vc(from) { to, navigationController in
            let vc = r.vc(to, continuation)
            navigationController.pushViewController(vc, animated: true)
        }
        return result
    }
    
    return VC(combined)
}
