//
//  ViewController.swift
//  Psychologist
//
//  Created by Alex Beltyukov on 6/7/15.
//  Copyright (c) 2015 Alex Beltyukov. All rights reserved.
//

import UIKit

class PsychologistViewController: UIViewController {

    @IBAction func nothing(sender: UIButton) {
        performSegueWithIdentifier("Show Nothing", sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var destination = segue.destinationViewController as? UIViewController
        if let navCon = destination as? UINavigationController, hvc = navCon.visibleViewController as? HappinessViewController {
            if let identifier = segue.identifier {
                switch identifier {
                    case "Show Sad Diagnosis": hvc.happiness = 0
                    case "Show Happy Diagnosis": hvc.happiness = 100
                    case "Show Nothing": hvc.happiness = 25
                    default: hvc.happiness = 50
                }
            }
        }
    }
}
