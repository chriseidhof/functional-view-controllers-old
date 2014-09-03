//
//  Either.swift
//  MasterDetail
//
//  Created by Chris Eidhof on 03/09/14.
//  Copyright (c) 2014 Chris Eidhof. All rights reserved.
//

import Foundation

class Box<A> {
    let value : A
    init(_ a: A) {
        self.value = a
    }
}

enum Either<A,B> {
    case Left(Box<A>)
    case Right(Box<B>)
}