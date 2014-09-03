//
//  FunctionalVC.swift
//  MasterDetail
//
//  Created by Chris Eidhof on 03/09/14.
//  Copyright (c) 2014 Chris Eidhof. All rights reserved.
//

import UIKit


// We define a struct, just so we can work with simpler types. Could be a typealias with generics (once that gets supported)

struct VC<From,To> {
    typealias Func = (From, (To, UINavigationController) -> ()) -> UIViewController
    let vc : Func
    
    init(_ vc: Func) {
        self.vc = vc
    }
}

// Present a chain of view controllers
func present<A>(navigationController: UINavigationController, initialValue: A, viewController: VC<A,()>) {
    let vc = viewController.vc(initialValue) { _, _ in () }
    navigationController.viewControllers = [vc]    
}

func or<A,B,R>(l: VC<A,R>, r: VC<B,R>) -> VC<Either<A,B>,R> {
    let combined : (Either<A,B>, (R, UINavigationController) -> ()) -> UIViewController = {
        (from, continuation) in
        switch from {
        case .Left(let a):
            return l.vc(a.value, continuation)
        case .Right(let b):
            return r.vc(b.value, continuation)
        }
    }
    return VC(combined)
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