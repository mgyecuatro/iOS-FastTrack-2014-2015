//
//  ViewController.swift
//  FirstApp
//
//  Created by Nicholas Outram on 22/12/2014.
//  Copyright (c) 2014 Plymouth University. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var messageLabel: UILabel!
    
    let messageArray : [String] = ["May the force be with you", "Live long and prosper", "To infinity and beyond", "Space is big. You just won't believe how vastly, hugely, mind- bogglingly big it is"]

    var index : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func doButtonTap(sender: AnyObject) {
        println("Button touched!")
        
        let nextString = self.messageArray[index]
        self.messageLabel.text = nextString
        index++
        index %= self.messageArray.count
    }

}

