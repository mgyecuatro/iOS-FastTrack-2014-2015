//
//  ViewController.swift
//  PickerDemo
//
//  Created by Nicholas Outram on 08/02/2015.
//  Copyright (c) 2015 Plymouth University. All rights reserved.
//
// This was used in the short lecture on UIPickerView and delegation
//

import UIKit

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var picker: UIPickerView!

    //**************************************************************************************
    //
    //MARK: Model data
    //
    //**************************************************************************************
    let arrayOfAdjectives = [ "Fast", "Slow", "Profound", "Diplomatic", "Famous", "Infamous", "Deadly", "Trustworthy"]
    
    let arrayOfThings = ["Camel", "Peg", "Saussage", "Hosepipe", "Digger", "Bludger"]
    //**************************************************************************************

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    //**************************************************************************************
    //
    //MARK: UIPickerViewDataSource
    //
    //**************************************************************************************
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return arrayOfAdjectives.count
            
        case 1:
            return arrayOfThings.count
            
        default:
            return 0
        }
    }
    
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 2
    }
    //**************************************************************************************
    
    
    
    
    //**************************************************************************************
    //
    //MARK: UIPickerViewDelegate
    //
    //**************************************************************************************
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        switch component {
        case 0:
            return arrayOfAdjectives[row]
            
        case 1:
            return arrayOfThings[row]
            
        default:
            return ""
        }
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch (component) {
        case 0:
            let selectedAdj = arrayOfAdjectives[row]
            println("You picked \(selectedAdj)")
        case 1:
            let selectedObj = arrayOfThings[row]
            println("You picked \(selectedObj)")
        default:
            println("Nothing to report here. Move along")
        }
    }
    //**************************************************************************************

    
    
}

