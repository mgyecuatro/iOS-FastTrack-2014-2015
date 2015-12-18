//
//  ViewController.swift
//  IdleDemo
//
//  Created by Nicholas Outram on 17/12/2015.
//  Copyright © 2015 Plymouth University. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

   @IBOutlet weak var progressView: UIProgressView!
   @IBOutlet weak var progressView2: UIProgressView!
   
   override func viewDidLoad() {
      super.viewDidLoad()
      // Do any additional setup after loading the view, typically from a nib.
   }

   override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
   }

   @IBAction func doNumberCrunch(sender: AnyObject) {
      guard let button = sender as? UIButton else {
         return
      }
      
      //Set UI State
      button.enabled = false
      self.progressView.progress = 0.0
      self.progressView2.progress = 0.0
      
      //Note the number of threads running
      var threads = 2
      
      // H.O.F. - returns a Block of code to run on a seperate thread
      // Captures the specific bar to update.
      func blockWithProgressBar(bar : UIProgressView) -> () -> () {
         
         // This closure is returned
         // We are basically using currying to capture the bar parameter
         let blockOfCode = {
            //Perform expensive computation
            var result = 0.0
            for var n : Int = 0; n<100; n++ {
               for var m : Int = 0; m<5000000; m++ {
                  result += Double(n)*Double(m) * (m%2==0 ? -1.0 : +1.0)
               }
               //Update UI on main thread - capturing 'bar' - note the trailing closure
               NSOperationQueue.mainQueue().addOperation(NSBlockOperation(){
                  bar.progress = Float(n)*0.01
               })
            }
            
            //Message main thread when done - note again the trailing closure
            NSOperationQueue.mainQueue().addOperation(NSBlockOperation(){
               //Reset GUI (only on main thread)
               bar.progress = 0.0
               //This is safe as it is queued on the main thread
               threads--
               if threads == 0 {
                  button.enabled = true
               }
            })
         }
         
         return blockOfCode
      }
      
      //Run on two seperate threads
      let Q = NSOperationQueue()
      let P1 = NSBlockOperation(block: blockWithProgressBar(progressView))
      let P2 = NSBlockOperation(block: blockWithProgressBar(progressView2))
      Q.addOperation(P1)
      Q.addOperation(P2)
   }
   
}

