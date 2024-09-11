//
//  term.swift
//  TestPrologCompiler
//
//  Created by Jan Blaakmeer on 11/09/2024.
//

import Foundation

typealias Term2 = Term

enum Term {
    case variable(String)     // Variabelen zoals `X`
    case constant(String)     // Constanten zoals `john`, `mary`
    case compound(String, [Term2]) // Functor zoals `father(X, Y)`
    
    func asVariable() -> String? {
        if case let .variable(v) = self {
            return v
        }
        return nil
    }
}
