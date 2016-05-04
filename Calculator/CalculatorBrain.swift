//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Ozan Asan on 5/3/16.
//  Copyright © 2016 Ozan Asan. All rights reserved.
//

import Foundation



class CalculatorBrain {
    private var accumulator = 0.0
    
    private var operations : Dictionary<String,Operation> = [
        "π" : Operation.Constant(M_PI),
        "e" : Operation.Constant(M_E),
        "√" : Operation.UnaryOperation(sqrt),
        "cos" : Operation.UnaryOperation(cos),
        "✕" : Operation.BinaryEquation( { $0 * $1 }),
        "-" : Operation.BinaryEquation( { $0 - $1 }),
        "+" : Operation.BinaryEquation( { $0 + $1 }),
        "÷" : Operation.BinaryEquation( { $0 / $1 }),
        "=" : Operation.Equals
     ]
    
    private enum Operation {
        case Constant(Double)
        case UnaryOperation((Double) -> Double)
        case BinaryEquation((Double, Double) -> Double)
        case Equals
    }
    
    func setOperand(operand : Double) {
        accumulator = operand
    }
    
    func performOperation(symbol : String) {
        if let operation = operations[symbol] {
            switch operation {
            case .Constant(let associatedValue):
                accumulator = associatedValue
            case .BinaryEquation(let function):
                executePendingBinaryOperation()
                pending = PendingBinaryOperationInfo(binaryFunction: function, firstOperand: accumulator)
            case .UnaryOperation(let function):
                accumulator = function(accumulator)
            case .Equals:
                executePendingBinaryOperation()
            }
        }
    }
    
    private func executePendingBinaryOperation() {
        if pending != nil {
            accumulator = pending!.binaryFunction(pending!.firstOperand, accumulator)
            pending = nil
        }
    }
    
    private var pending : PendingBinaryOperationInfo?
    
    private struct PendingBinaryOperationInfo {
        var binaryFunction: (Double, Double) -> Double
        var firstOperand: Double
    }
    
    var result : Double {
        get {
            return accumulator
        }
    }
}