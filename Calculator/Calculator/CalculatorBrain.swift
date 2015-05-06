//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Alex Beltyukov on 4/5/15.
//  Copyright (c) 2015 Alex Beltyukov. All rights reserved.
//

import Foundation

class CalculatorBrain {
    
    private enum Op: Printable {
        case Operand(Double)
        case Constant(String, Double)
        case Variable(String)
        case UnaryOperation(String, Double -> Double)
        case BinaryOperation(String, (Double, Double) -> Double)
        
        var description: String {
            get {
                switch self {
                case .Operand(let operand):
                    return "\(operand)"
                case .Constant(let symbol, _):
                    return symbol
                case .Variable(let variable):
                    return variable
                case .UnaryOperation (let symbol, _):
                    return symbol
                case .BinaryOperation(let symbol, _):
                    return symbol
                }
            }
        }
    }
    
    private var knownOps = [String:Op]()
    
    init() {
        func learnOp(op: Op) {
            knownOps[op.description] = op
        }
        learnOp(Op.BinaryOperation("+", +))
        learnOp(Op.BinaryOperation("−") { $1 - $0 })
        learnOp(Op.BinaryOperation("×", *))
        learnOp(Op.BinaryOperation("÷") { $1 / $0 })
        learnOp(Op.UnaryOperation("√", sqrt))
        learnOp(Op.UnaryOperation("sin") { sin($0) })
        learnOp(Op.UnaryOperation("cos") { cos($0) })
        learnOp(Op.Constant("∏", M_PI))
    }
    
    var description: String {
        var finalHistory = " "
        var (history, remainingOps) = description(opStack)
        if let unwrappedHistory = history {
            finalHistory = unwrappedHistory
        }
        
        while !remainingOps.isEmpty {
            (history, remainingOps) = description(remainingOps)
            if let unwrappedHistory = history {
                finalHistory += ", \(unwrappedHistory)"
            }
        }
        
        return finalHistory
    }
    
    private func description(ops: [Op]) -> (result: String?, remainingOps: [Op]) {
        if !opStack.isEmpty {
            var remainingOps = ops
            let op = remainingOps.removeLast()
            switch op {
            case .Operand(let operand):
                return ("\(operand)", remainingOps)
            case .Constant(let constant, _):
                return ("\(constant)", remainingOps)
            case .Variable(let variable):
                return ("\(variable)", remainingOps)
            case .UnaryOperation(let unaryOperation, _):
                let operandDescription = description(remainingOps)
                if let operand = operandDescription.result {
                    return ("\(unaryOperation)(\(operand))", operandDescription.remainingOps)
                }
            case .BinaryOperation(let binaryOperation, _):
                let op1Description = description(remainingOps)
                if let operand1 = op1Description.result {
                    let op2Description = description(op1Description.remainingOps)
                    if let operand2 = op2Description.result {
                        var binaryHistory: String
                        if binaryOperation == "−" || binaryOperation == "÷" {
                            binaryHistory = "(\(operand2)\(binaryOperation)\(operand1))"
                        } else {
                            binaryHistory = "\(operand1)\(binaryOperation)\(operand2)"
                            if binaryOperation == "+" {
                                binaryHistory = "(\(binaryHistory))"
                            }
                        }
                        
                        return (binaryHistory, op2Description.remainingOps)
                    }
                }
            }
        }
        return (nil, ops)
    }
    
    func evaluate() -> Double? {
        let (result, remainder) = evaluate(opStack)
        if let evaluateResult = result {
            println("\(opStack) = \(evaluateResult) with remainder \(remainder)")
        }
        return result
    }
    
    private func evaluate(ops: [Op]) -> (result: Double?, remainingOps: [Op]) {
        if !ops.isEmpty {
            var remainingOps = ops
            let op = remainingOps.removeLast()
            switch op {
            case .Operand(let operand):
                return (operand, remainingOps)
            case .Constant(_, let value):
                return (value, remainingOps)
            case .Variable(let symbol):
                if let variableValue = variableValues[symbol] {
                    return (variableValue, remainingOps)
                } else {
                    return (nil, remainingOps)
                }
            case .UnaryOperation(_, let operation):
                let operandEvaluation = evaluate(remainingOps)
                if let operand = operandEvaluation.result {
                   return (operation(operand), operandEvaluation.remainingOps)
                }
            case .BinaryOperation(_, let operation):
                let op1Evaluation = evaluate(remainingOps)
                if let operand1 = op1Evaluation.result {
                    let op2Evaluation = evaluate(op1Evaluation.remainingOps)
                    if let operand2 = op2Evaluation.result {
                        return (operation(operand1, operand2), op2Evaluation.remainingOps)
                    }
                }
            }
        }
        return (nil, ops)
    }
    
    private var opStack = [Op]()
    var variableValues = [String: Double]()
    
    func clearOpStack() {
        opStack.removeAll(keepCapacity: false)
    }
    
    func pushOperand(symbol: String) -> Double? {
        opStack.append(Op.Variable(symbol))
        return evaluate()
    }
    
    func pushOperand(operand: Double) -> Double? {
        opStack.append(Op.Operand(operand))
        return evaluate()
    }
    
    func performOperation(symbol: String) -> Double? {
        if let operation = knownOps[symbol] {
            opStack.append(operation)
        }
        return evaluate()
    }
}
