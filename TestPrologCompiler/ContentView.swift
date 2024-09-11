//
//  ContentView.swift
//  TestPrologCompiler
//
//  Created by Jan Blaakmeer on 10/09/2024.
//

import SwiftUI

import SwiftUI

struct ContentView: View {
    
    @State var input: String =
        """
        parent(john, mary).
        parent(mary, susan).
        parent(bob, john).
        """
    @State var output: String = ""
    @State var query: String = "parent(X,mary)."

    func token() -> () {
        output = "TOKENS\n======\n"
        let lexer = Lexer(input: input)
        let tokens = lexer.tokenize()
        for token in tokens {
            output.append("\(token)\n")
        }
    }
    func parser() -> () {
        output = "\nNODES\n=====\n"
        let lexer = Lexer(input: input)
        let tokens = lexer.tokenize()
        let parser = Parser(tokens: tokens)
        let ast = parser.parse()
        for node in ast {
            output.append("\(node)\n")
        }
    }
    func interpreter() -> () {
        output = "INTERPRETING\n============\n"
        let lexer = Lexer(input: input)
        let tokens = lexer.tokenize()
        let parser = Parser(tokens: tokens)
        let ast = parser.parse()
        let interpreter = Interpreter()
        interpreter.interpret(ast: ast)
        for node in ast {
            output.append("\(node)\n")
        }
    }
    func check() -> () {
        output = "Query\n=====\n"
        let lexer = Lexer(input: input)
        let tokens = lexer.tokenize()
        let parser = Parser(tokens: tokens)
        let ast = parser.parse()
        let interpreter = Interpreter()
        interpreter.interpret(ast: ast)
        
        
        if let queryResults = interpreter.query("parent", [.variable("X"), .variable("Y")]) {
            for result in queryResults {
                output.append("Query result: \(result)")
            }
        } else {
            output.append("No results found")
        }
    }

    var body: some View {
        VStack {
            TextEditor(text: $input)
            HStack {
                Button(action: token, label: {
                    Text("Tokenize")
                })
                Button(action: parser, label: {
                    Text("Parsing")
                })
                Button(action: interpreter, label: {
                    Text("Interpreting")
                })
            }
            VStack {
                TextEditor(text: $query)
                    .lineLimit(2)
                Button(action: check, label: {
                    Text("Check")
                })
            }
            TextEditor(text: $output)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
