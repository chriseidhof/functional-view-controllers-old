//
//  FunctionalVC.swift
//  MasterDetail
//
//  Created by Chris Eidhof on 03/09/14.
//  Copyright (c) 2014 Chris Eidhof. All rights reserved.
//

import UIKit


struct VC<From,To> {
    typealias Func = (From, (To, UINavigationController) -> ()) -> UIViewController
    let vc : Func
    
    init(_ vc: Func) {
        self.vc = vc
    }
}

func present<A>(navigationController: UINavigationController, initialValue: A, viewController: VC<A,()>) {
    let vc = viewController.vc(initialValue) { _, _ in () }
    navigationController.viewControllers = [vc]    
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