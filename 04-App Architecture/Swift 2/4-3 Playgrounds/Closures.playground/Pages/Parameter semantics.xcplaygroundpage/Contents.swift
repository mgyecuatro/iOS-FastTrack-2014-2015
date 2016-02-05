//: [Previous](@previous)
import UIKit
import XCPlayground
//: ![Closures](Banner.jpg)

//: ## Parameter and Return Types

//: ### Default values cannot be used for closures

//: ### Optional Parameters - same as functions
let message = { (name : String, title : String?) -> String in
   var message = "Greetings "
   
   if let t = title {
      message += ( t + " " )
   }
   
   message += name
   return message
}

message("Spock", "Mr")
message("Bones", nil)

//: ### Variable Parameters - same as functions
//: To save creating another local variable, you can make a parameter a variable.
//: Note:
//: * the parameter is *an independent copy*, not a reference to the original
//: * as it is a parameter, it is already initialised
let mac = { (var accumulator: Double, x : Double, y : Double) -> Double in
   //accumulator is a copy - not the original
   accumulator += x*y
   return accumulator
}

//: The variable `a` is an accumulator (stores a running sum)
var a : Double = 0.0
//: Note - the function mac is not modifying `a` inline
a = mac(a, 2.0, 3.0)  // a = a + 6
a = mac(a, 5.0, 2.0)  // a = a + 10

//: ### inout parameters - same as functions
let mac2 = { ( inout accumulator: Double, x : Double, y : Double) in
   accumulator += x*y
}
a = 0.0
mac2(&a, 2.0, 3.0)
mac2(&a, 5.0, 2.0)

//: ### variable number of parameters - same as functions 

let recipe = { (t: String, ingredients: String...) -> String in
   
   var description = "<P><h2>" + t + "</h2><ul>"
   for ingredient in ingredients {
      description += "<li>" + ingredient + "</li>"
   }
   description+="</ul>"
   return description
}

let page = recipe("Perfect Breakfast", "Cold Pizza", "Meat-balls", "Biriani")
let wv = UIWebView(frame: CGRectMake(0,0,200,200))
wv.loadHTMLString(page, baseURL: nil)

//: To see the output of this, turn on the Assistant View
XCPlaygroundPage.currentPage.liveView = wv


