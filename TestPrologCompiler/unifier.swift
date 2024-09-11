//
//  unifier.swift
//  TestPrologCompiler
//
//  Created by Jan Blaakmeer on 11/09/2024.
//

import Foundation

class Unifier {
    typealias Substitution = [String: Term]
    
    func unify(_ term1: Term, _ term2: Term, _ substitutions: Substitution = [:]) -> Substitution? {
        let result = unifyHelper(term1, term2, substitutions)
        return result != nil ? result : nil
    }
    
    private func unifyHelper(_ term1: Term, _ term2: Term, _ subs: Substitution) -> Substitution? {
        switch (term1, term2) {
            case let (.variable(v), term), let (term, .variable(v)):
                return unifyVariable(v, term, subs)
            case let (.constant(c1), .constant(c2)):
                return c1 == c2 ? subs : nil
            case let (.compound(f1, args1), .compound(f2, args2)):
                guard f1 == f2, args1.count == args2.count else {
                    return nil
                }
                return unifyArguments(args1, args2, subs)
            default:
                return nil
        }
    }
    
    private func unifyVariable(_ variable: String, _ term: Term, _ subs: Substitution) -> Substitution? {
        if let binding = subs[variable] {
            return unifyHelper(binding, term, subs)
        } else if let binding = term.asVariable(), binding == variable {
            return subs // Zelfde variabele
        } else if occursCheck(variable, in: term) {
            return nil // Occurs check: voorkom oneindige loops
        } else {
            var newSubs = subs
            newSubs[variable] = term
            return newSubs
        }
    }
    
    private func unifyArguments(_ args1: [Term], _ args2: [Term], _ subs: Substitution) -> Substitution? {
        var currentSubs = subs
        for (arg1, arg2) in zip(args1, args2) {
            guard let newSubs = unifyHelper(arg1, arg2, currentSubs) else {
                return nil
            }
            currentSubs = newSubs
        }
        return currentSubs
    }
    
    private func occursCheck(_ variable: String, in term: Term) -> Bool {
        switch term {
            case .variable(let v):
                return v == variable
            case .compound(_, let args):
                return args.contains { occursCheck(variable, in: $0) }
            default:
                return false
        }
    }
}
