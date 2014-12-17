//
//  ViewController.swift
//  Demo
//
//  Created by Nicholas Outram on 17/12/2014.
//  Copyright (c) 2014 Nicholas Outram. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    //Weak reference to the label
    @IBOutlet weak var demoLabel: UILabel!
    
    //This is run each time the view controller it loaded
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func doDemo(sender: AnyObject) {
        
        //Useful closure to extract the time in a given format
        let time = { (format : String) -> String in
            let date = NSDate()
            let fmt = NSDateFormatter()
            fmt.dateFormat = format
            let desc = fmt.stringFromDate(date)
            return desc
        }
        
        //Update the label to show the current time
        self.demoLabel.text = time("HH:mm:ss")
    }

}

