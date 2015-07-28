//
//  ViewController.swift
//  BMI
//
//  Created by Nicholas Outram on 30/12/2014.
//  Copyright (c) 2014 Plymouth University. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {

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
    @IBOutlet weak var heightPickerView: UIPickerView!
    @IBOutlet weak var weightPickerView: UIPickerView!
    
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
        } else {
            self.bmiLabel.text = "----"
        }
    }
    
//    func textFieldDidEndEditing(textField: UITextField) {
//        
//        let conv = { NSNumberFormatter().numberFromString($0)?.doubleValue }
//        
//        switch (textField) {
//            
//        case self.weightTextField:
//            self.weight = conv(textField.text)
//            
//        case self.heightTextField:
//            self.height = conv(textField.text)
//            
//        default:
//            println("Error");
//            
//        }
//        
//        updateUI()
//        
//    }
    
    // SOLUTION TO CHALLENGE
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        let conv = { NSNumberFormatter().numberFromString($0)?.doubleValue }
        
        guard let txt = textField.text else {
            return false
        }
        
        let newString = NSMutableString(string: txt)
        newString.replaceCharactersInRange(range, withString: string)
        
        switch (textField) {
            
        case self.weightTextField:
            self.weight = conv(newString as String)
            
        case self.heightTextField:
            self.height = conv(newString as String)
            
        default:
            break
            
        }
        
        updateUI()
        
        return true
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch (pickerView) {
        case self.heightPickerView:
            return listOfHeightsInM.count
            
        case self.weightPickerView:
            return listOfWeightsInKg.count
            
        default:
            return 0
        }
    }
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch (pickerView) {
        case self.heightPickerView:
            return String(format: "%4.2f", listOfHeightsInM[row])
            
        case self.weightPickerView:
            return String(format: "%4.1f", listOfWeightsInKg[row])
            
        default:
            return ""
        }
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch (pickerView) {
        case self.heightPickerView:
            let h : Double = self.listOfHeightsInM[row]
            self.height = h
            
        case self.weightPickerView:
            let w : Double = self.listOfWeightsInKg[row]
            self.weight = w
            
        default:
            print("Error");
        }
        
        updateUI()
    }
    
  
    
    
}

