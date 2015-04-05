//
//  ViewController.swift
//  Calculator
//
//  Created by Alex Beltyukov on 3/28/15.
//  Copyright (c) 2015 Alex Beltyukov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var history: UILabel!
    var userIsInMiddleOfTypingNumber = false
    
    @IBAction func clear() {
        display.text! = "0"
        history.text! = " "
        operandStack = []
    }
    
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsInMiddleOfTypingNumber {
            if digit == "." {
                display.text! += display.text!.rangeOfString(".") == nil ? digit : ""
            } else {
                display.text! += digit
            }
        } else {
            display.text! = digit
            userIsInMiddleOfTypingNumber = true
        }
        history.text! += " \(digit)"
    }
    
    @IBAction func operate(sender: UIButton) {
        let operation = sender.currentTitle!
        if userIsInMiddleOfTypingNumber {
            enter()
        }
        history.text! += " \(operation)"
        switch operation {
        case "×": performOperation { $0 * $1 }
        case "÷": performOperation { $1 / $0 }
        case "+": performOperation { $0 + $1 }
        case "−": performOperation { $1 - $0 }
        case "√": performOperation { sqrt($0) }
        case "sin": performOperation { sin($0) }
        case "cos": performOperation { cos($0) }
        case "∏": displayValue = M_PI; enter()
        default: break
        }
    }
    
    func performOperation(operation: (Double, Double) -> Double) {
        if operandStack.count >= 2 {
            displayValue = operation(operandStack.removeLast(), operandStack.removeLast())
            enter()
        }
    }
    
    func performOperation(operation: Double -> Double) {
        if operandStack.count >= 1 {
            displayValue = operation(operandStack.removeLast())
            enter()
        }
    }
    
    var operandStack = Array<Double>()
    @IBAction func enter() {
        userIsInMiddleOfTypingNumber = false
        operandStack.append(displayValue)
        history.text! += "  "
        println("Operand stack: \(operandStack)")
    }
    
    var displayValue: Double {
        get {
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        set {
            display.text = "\(newValue)"
            userIsInMiddleOfTypingNumber = false
        }
    }
}
