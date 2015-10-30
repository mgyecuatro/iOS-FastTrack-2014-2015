//
//  ViewController.swift
//  BMI
//
//  Created by Nicholas Outram on 30/12/2014.
//  Copyright (c) 2014 Plymouth University. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    let listOfWeightsInKg = Array(80...240).map( { Double($0) * 0.5 } )
    let listOfHeightsInM  = Array(140...220).map( { Double($0) * 0.01 } )

    var weight : Double?
    var height : Double?
    var bmi : Double? {
        get {
            if (weight != nil) && (height != nil) {
                return weight! / (height! * height!)
            } else {
                return nil
            }
        }
    }
    
    @IBOutlet weak var bmiLabel: UILabel!
    @IBOutlet weak var heightTextField: UITextField!
    @IBOutlet weak var weightTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        updateUI()
        return true
    }
    
    func updateUI() {
        if let val = self.bmi {
            self.bmiLabel.text = String(format: "%4.1f", val)
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        
        let conv = { NSNumberFormatter().numberFromString($0)?.doubleValue }
        
        switch (textField) {
            
        case self.weightTextField:
            self.weight = conv(textField.text)
            
        case self.heightTextField:
            self.height = conv(textField.text)
            
        default:
            println("Error");
            
        }
        
        updateUI()
        
    }
    
    
}

