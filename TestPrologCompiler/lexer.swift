//
//  lexer.swift
//  TestPrologCompiler
//
//  Created by Jan Blaakmeer on 11/09/2024.
//

import Foundation

class Lexer {
    private let input: String
    private var currentIndex: String.Index
    
    init(input: String) {
        self.input = input
        self.currentIndex = input.startIndex
    }
    
    private func peek() -> Character? {
        return currentIndex < input.endIndex ? input[currentIndex] : nil
    }
    
    private func advance() {
        currentIndex = input.index(after: currentIndex)
    }
    
    func tokenize() -> [Token] {
        var tokens = [Token]()
        
        while let char = peek() {
            switch char {
                case "(":
                    tokens.append(.openParen)
                    advance()
                case ")":
                    tokens.append(.closeParen)
                    advance()
                case ",":
                    tokens.append(.comma)
                    advance()
                case ".":
                    tokens.append(.period)
                    advance()
                case ";":
                    tokens.append(.semicolon)
                    advance()
                case "a"..."z", "A"..."Z":
                    let identifier = readIdentifier()
                    tokens.append(.identifier(identifier))
                default:
                    advance() // Sla spaties of onbekende tekens over
            }
        }
        
        tokens.append(.endOfFile)
        return tokens
    }
    
    private func readIdentifier() -> String {
        var result = ""
        while let char = peek(), char.isLetter {
            result.append(char)
            advance()
        }
        return result
    }
}
