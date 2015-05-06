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
        displayValue = 0
        history.text! = " "
        calculatorBrain.clearOpStack()
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
//        history.text! += " \(digit)"
    }
    
    @IBAction func viewHistory() {
        println("HISTORY: \(calculatorBrain.description)")
    }
    
    @IBAction func operate(sender: UIButton) {
        if userIsInMiddleOfTypingNumber {
            enter()
        }
        if let operation = sender.currentTitle, result = calculatorBrain.performOperation(operation) {
            history.text! = calculatorBrain.description
            displayValue = result
        } else {
            clear()
        }
    }

    @IBAction func enter() {
        userIsInMiddleOfTypingNumber = false
        if let value = displayValue, result = calculatorBrain.pushOperand(value) {
            displayValue = result
        } else {
            clear()
        }
    }
    
    var displayValue: Double? {
        get {
            return NSNumberFormatter().numberFromString(display.text!)?.doubleValue
        }
        set {
            display.text = "\(newValue!)"
            userIsInMiddleOfTypingNumber = false
        }
    }
}
