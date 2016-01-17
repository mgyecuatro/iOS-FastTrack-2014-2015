//
//  ViewController.swift
//  ResponderChainDemo
//
//  Created by Nicholas Outram on 15/01/2016.
//  Copyright © 2016 Plymouth University. All rights reserved.
//

import UIKit

extension UIResponder {
    func switchState(t : Int) -> Bool? {
        guard let me = self as? UIView else {
            return nil
        }
        for v in me.subviews {
            if let sw = v as? UISwitch where v.tag == t {
                return sw.on
            }
        }
        return false
    }
    
    func printNextRepsonderAsString() {
        var result : String = "\(self.dynamicType) got a touch event."
        
        if let nr = self.nextResponder() {
            result += " The next responder is " + nr.dynamicType.description()
        } else {
            result += " This class has no next responder"
        }
        
        print(result)
    }
}


class ViewController: UIViewController {
    
    @IBOutlet weak var passUpSwitch: UISwitch!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.printNextRepsonderAsString()
        
        if passUpSwitch.on {
            //Pass up the responder chain
            super.touchesBegan(touches, withEvent: event)
        }
    }

}

