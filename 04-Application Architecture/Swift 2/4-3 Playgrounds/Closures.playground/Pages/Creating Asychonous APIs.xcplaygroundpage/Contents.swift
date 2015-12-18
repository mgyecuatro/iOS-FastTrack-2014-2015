//: [Previous](@previous)

import UIKit
import XCPlayground
//: ![Closures](Banner.jpg)

//: ## Creating an Asychronous API
//:
//: To make like simpler for the developer, let's create a second version of the hill-climb function that
//: provides an asychonrous call-back **on the main thread**.

//: The following is needed to allow the execution of the playground to continue beyond the scope of the higher-order function.
XCPlaygroundPage.currentPage.needsIndefiniteExecution = true


let deg2rad = { $0*M_PI/180.0 }
let rad2deg = { $0 * 180.0 / M_PI }

//: ### Create asychronous API
//: This call-back function is passed as the last parameter. This parameter is a function with one parameter.
//: The objective of the higher order function is to iterate "up hill" to find the nearest peak
typealias SOLN = (x: Double, y : Double)
func hillClimbWithInitialValue(var x0 : Double, 𝛌 : Double, maxIterations: Int, fn : Double->Double, completion: SOLN?->Void) {
   
   //Encapsualte code in a parameterless closure
   let P1 = {
      
      func estimateSlope(x : Double) -> Double {
         let 𝛅 = 1e-6
         let 𝛅2 = 2*𝛅
         return ( fn(x+𝛅)-fn(x-𝛅) ) / 𝛅2
      }
      
      var slope = estimateSlope(x0)
      var iteration = 0
      
      while (fabs(slope) > 1e-6) && (iteration < maxIterations) {
         
         //For a positive slope, increase x
         x0 += 𝛌 * slope
         
         //Update the gradient estimate
         slope = estimateSlope(x0)
         
         //Update count
         iteration++
      }
      
      //Create an Operation to perform a callback passing the result as a parameter
      let P2 = {
         //Capture iteration and maxIterations
         if iteration < maxIterations {
            //Capture x0 and fn(x0)
            let res = ( x:x0, y:fn(x0) )
            //Pass back result
            completion( res )
         } else {
            //Did not converge
            completion( nil )
         }
      }
      
      //Perform call back on main thread
      NSOperationQueue.mainQueue().addOperationWithBlock(P2)   //P2 will be a copy
      
   } //end of closure

   //Perform operation on seperate thread
   NSOperationQueue().addOperationWithBlock(P1)
}

//: ### Invoke asychronous function
//: The developer now has a simpler task.

//: First, define two closures:
//: * The function being searched
let fcn : Double->Double = { sin($0) }
//: * A callback closure (which is performed in the runloop of the main thread)
let complete = { (solution : SOLN?) -> Void in
   print("Completed: \(NSDate())", separator: "")

   if let s = solution {
      print("Peak of value \(s.y) found at x=\(rad2deg(s.x)) degrees", separator: "")
   } else {
      print("Did not converge")
   }
}
//: Invoke
hillClimbWithInitialValue(0.1, 𝛌: 0.01, maxIterations: 10000, fn: fcn, completion: complete)
print("Started: \(NSDate())", separator: "")
//: Look at the times - you can see the call-back has occured after the start, and that the duration is significant (in the order of seconds). Note this is likely to be somewhat different for a Playground, but the principle is the same. Network transactions can be much longer.

//: #### Grand Central Dispatch (alternative)
//: While we are on the subject of multi-threaded code, `NSOperationQueue` is built on a lower-level technology, *Grand Central Dispatch* (GCD). This is commonly used, so it is worth highlighting.

//: Let's return to the original synchronous function
func synchronousHillClimbWithInitialValue(var x0 : Double, 𝛌 : Double, maxIterations: Int, fn : (Double) -> Double ) -> (x: Double, y : Double)? {
   
   func estimateSlope(x : Double) -> Double {
      let 𝛅 = 1e-6
      let 𝛅2 = 2*𝛅
      return ( fn(x+𝛅)-fn(x-𝛅) ) / 𝛅2
   }
   
   var slope = estimateSlope(x0)
   var iteration = 0
   while (fabs(slope) > 1e-6) {
      
      //For a positive slope, increase x
      x0 += 𝛌 * slope
      
      //Update the gradient estimate
      slope = estimateSlope(x0)
      
      //Update count
      iteration++
      
      if iteration == maxIterations {
         return nil
      }
   }
   
   return (x:x0, y:fn(x0))
}

//: Create a queue (separate thread) where all tasks can run concurrently
let q = dispatch_queue_create("calc", DISPATCH_QUEUE_CONCURRENT)

//: Dispatch the task on the queue
dispatch_async(q){
   //Call the (computationally intensive) function
   let solution = synchronousHillClimbWithInitialValue(0.01, 𝛌: 0.01, maxIterations: 10000, fn: sin)
//: * Perform call-back on main thread. Again, the code is a parameterless trailing-closure.
   dispatch_sync(dispatch_get_main_queue()) {
      if let s = solution {
         print("GCD: Peak of value \(s.y) found at x=\(rad2deg(s.x)) degrees", separator: "")
      } else {
         print("GCD: Did not converge")
      }
   }
}

//: A difficulty with such asychronous APIs is *managing state*, i.e. keeping track of what tasks have completed, including cases where operations may have been unsuccessful.
//:
//: You can think of the asychrounous callbacks as events posted into a run-loop. Different threads of execution can have their own run-loop (read up on `NSThread`  and the Concurrency Programming Guide if you are curious).

//: Often, callbacks are *posted* on the runloop for the *main thread* making them much like an `Action` (e.g. tapping a `UIButton`). There are challenges in managing code that uses a lot of asychrnous APIs. I the *breadcrumbs' app (to follow), I am going too show you one that I tend to use: *finite state machines*.


//: [Next](@next)
