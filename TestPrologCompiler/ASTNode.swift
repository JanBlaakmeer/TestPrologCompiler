//
//  ASTNode.swift
//  TestPrologCompiler
//
//  Created by Jan Blaakmeer on 11/09/2024.
//

import Foundation

enum ASTNode {
    case fact(String, [Term])          // Een feit, zoals `father(john, mary)`
    case rule(String, [Term], [ASTNode])  // Een regel, zoals `parent(X, Y) :- father(X, Y), mother(X, Y)`
    case conjunction([ASTNode])        // Logische AND
    case disjunction([ASTNode])        // Logische OR
}

