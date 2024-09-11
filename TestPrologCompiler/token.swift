//
//  token.swift
//  TestPrologCompiler
//
//  Created by Jan Blaakmeer on 11/09/2024.
//

import Foundation

enum Token: Equatable {
    case identifier(String)  // Voor identifiers zoals `father`, `john`
    case openParen           // Voor '('
    case closeParen          // Voor ')'
    case comma               // Voor ','
    case period              // Voor '.'
    case semicolon           // Voor ';' (gebruik voor OR)
    case endOfFile           // Einde van de invoer
}
