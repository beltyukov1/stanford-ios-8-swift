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
    var calculatorBrain = CalculatorBrain()
    
    @IBAction func clear() {
        display.text! = "0"
        history.text! = " "
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
        if userIsInMiddleOfTypingNumber {
            enter()
        }
        if let operation = sender.currentTitle, result = calculatorBrain.performOperation(operation) {
            history.text! += " \(operation)"
            displayValue = result
        } else {
            displayValue = 0
        }
    }

    @IBAction func enter() {
        userIsInMiddleOfTypingNumber = false
        history.text! += "  "
        if let result = calculatorBrain.pushOperand(displayValue) {
            displayValue = result
        } else {
            displayValue = 0
        }
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
