//
//  interpreter.swift
//  TestPrologCompiler
//
//  Created by Jan Blaakmeer on 11/09/2024.
//

import Foundation

class Interpreter {
    private var facts: [String: [[Term]]] = [:]
    private var rules: [String: [(head: [Term], body: [ASTNode])]] = [:] // Opslag voor regels
    
    func interpret(ast: [ASTNode]) {
        for node in ast {
            switch node {
                case let .fact(name, args):
                    if facts[name] != nil {
                        facts[name]?.append(args)
                    } else {
                        facts[name] = [args]
                    }
                case let .rule(name, headArgs, body):
                    if rules[name] != nil {
                        rules[name]?.append((head: headArgs, body: body))
                    } else {
                        rules[name] = [(head: headArgs, body: body)]
                    }
                case let .conjunction(nodes):
                    if evaluateConjunction(nodes) {
                        print("Conjunction succeeded")
                    }
                case let .disjunction(nodes):
                    if evaluateDisjunction(nodes) {
                        print("Disjunction succeeded")
                    }
            }
        }
    }
    
    private func evaluateConjunction(_ nodes: [ASTNode]) -> Bool {
        for node in nodes {
            if !evaluateNode(node) {
                return false
            }
        }
        return true
    }
    
    private func evaluateDisjunction(_ nodes: [ASTNode]) -> Bool {
        for node in nodes {
            if evaluateNode(node) {
                return true
            }
        }
        return false
    }
    
    private func evaluateNode(_ node: ASTNode) -> Bool {
        switch node {
            case let .fact(name, args):
                return query(name, args) != nil
            case let .conjunction(nodes):
                return evaluateConjunction(nodes)
            case let .disjunction(nodes):
                return evaluateDisjunction(nodes)
            default:
                return false
        }
    }
    
        /// Uitbreiden van de query methode om ook regels te evalueren
    func query(_ name: String, _ args: [Term]) -> [Unifier.Substitution]? {
            // Eerst controleren we feiten
        if let factList = facts[name] {
            var results: [Unifier.Substitution] = []
            for factArgs in factList {
                let unifier = Unifier()
                if let substitution = unifier.unify(.compound(name, args), .compound(name, factArgs)) {
                    results.append(substitution)
                }
            }
            if !results.isEmpty {
                return results
            }
        }
        
            // Vervolgens controleren we regels
        if let ruleList = rules[name] {
            var results: [Unifier.Substitution] = []
            for rule in ruleList {
                let unifier = Unifier()
                if let substitution = unifier.unify(.compound(name, args), .compound(name, rule.head)) {
                        // Voer het lichaam van de regel uit met de gevonden substituties
                    let bodySuccess = evaluateRuleBody(rule.body, substitution: substitution)
                    if bodySuccess {
                        results.append(substitution)
                    }
                }
            }
            return results.isEmpty ? nil : results
        }
        
        return nil
    }
    
        /// Evalueren van het lichaam van een regel met de gegeven substituties
    private func evaluateRuleBody(_ body: [ASTNode], substitution: Unifier.Substitution) -> Bool {
            // Voor elke node in het lichaam van de regel, voeren we de node uit
        for node in body {
                // Substitueer de variabelen in de node met de gevonden substituties
            let substitutedNode = substituteVariables(in: node, with: substitution)
            if !evaluateNode(substitutedNode) {
                return false
            }
        }
        return true
    }
    
        /// Hulpmethode om substituties toe te passen op een ASTNode
    private func substituteVariables(in node: ASTNode, with substitution: Unifier.Substitution) -> ASTNode {
        switch node {
            case let .fact(name, args):
                let substitutedArgs = args.map { applySubstitution($0, substitution: substitution) }
                return .fact(name, substitutedArgs)
            case let .conjunction(nodes):
                let substitutedNodes = nodes.map { substituteVariables(in: $0, with: substitution) }
                return .conjunction(substitutedNodes)
            case let .disjunction(nodes):
                let substitutedNodes = nodes.map { substituteVariables(in: $0, with: substitution) }
                return .disjunction(substitutedNodes)
            default:
                return node
        }
    }
    
        /// Hulpmethode om substituties op een Term toe te passen
    private func applySubstitution(_ term: Term, substitution: Unifier.Substitution) -> Term {
        switch term {
            case let .variable(name):
                return substitution[name] ?? term
            case let .compound(functor, args):
                let substitutedArgs = args.map { applySubstitution($0, substitution: substitution) }
                return .compound(functor, substitutedArgs)
            default:
                return term
        }
    }
}
