//
//  Operators.swift
//  ParserJson
//
//  Created by Valerio Ferrucci on 14/11/14.
//  Copyright (c) 2014 Valerio Ferrucci. All rights reserved.
//

infix operator >>> { associativity left precedence 150 }

func >>><A, B>(o: A?, f: A -> B?) -> B? {
    
    if let _o = o {
        
        return f(_o)
    
    } else {
    
        return .None
    
    }
}

infix operator <^> { associativity left }

func <^><A, B>(f: A -> B, a: A?) -> B? {
    if let x = a {
        return f(x)
    } else {
        return .None
    }
}

infix operator <*> { associativity left }

func <*><A, B>(f: (A -> B)?, a: A?) -> B? {
    if let fx = f {
        if let x = a {
            return fx(x)
        }
    }
    return .None
}
