//
//  parser.swift
//  TestPrologCompiler
//
//  Created by Jan Blaakmeer on 11/09/2024.
//

import Foundation

class Parser {
    private let tokens: [Token]
    private var currentIndex = 0
    
    init(tokens: [Token]) {
        self.tokens = tokens
    }
    
    private func currentToken() -> Token {
        return currentIndex < tokens.count ? tokens[currentIndex] : .endOfFile
    }
    
    private func advance() {
        currentIndex += 1
    }
    
    func parse() -> [ASTNode] {
        var nodes = [ASTNode]()
        
        while case let token = currentToken(), token != .endOfFile {
            if let node = parseFact() {
                nodes.append(node)
            } else {
                break
            }
        }
        
        return nodes
    }
    
    private func parseFact() -> ASTNode? {
        guard case let .identifier(name) = currentToken() else {
            return nil
        }
        advance()
        
        guard currentToken() == .openParen else {
            return nil
        }
        advance()
        
        var args = [Term]()
        while case let .identifier(arg) = currentToken() {
            args.append(.constant(arg))
            advance()
            
            if currentToken() == .comma {
                advance()
            } else if currentToken() == .closeParen {
                break
            }
        }
        
        guard currentToken() == .closeParen else {
            return nil
        }
        advance()
        
        guard currentToken() == .period else {
            return nil
        }
        advance()
        
        return .fact(name, args)
    }
}

