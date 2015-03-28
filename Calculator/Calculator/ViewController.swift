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
    var userIsInMiddleOfTypingNumber: Bool = false
    
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsInMiddleOfTypingNumber {
            display.text! += digit
        } else {
            display.text! = digit
            userIsInMiddleOfTypingNumber = true
        }
    }
}
