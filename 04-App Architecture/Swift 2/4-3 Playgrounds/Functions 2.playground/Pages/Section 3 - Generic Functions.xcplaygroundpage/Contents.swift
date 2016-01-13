//: [Previous](@previous)

import UIKit
import XCPlayground

//: ![Functions Part 2](banner.png)

//: # Functions Part 2 - Section 3
//: Version 2 - updated for Swift 2
//:
//: 23-11-2015
//:
//: This playground is designed to support the materials of the lecure "Functions 2".

//: ## Generic Functions

//: Consider the following function
func swapInt( tupleValue : (Int, Int) ) -> (Int, Int) {
   let y = (tupleValue.1, tupleValue.0)
   return y
}

let u2 = (2,3)
let v2 = swapInt( u2 )

//: This function only works with type Int. It cannot be used for other types. This is where Generics come in. The compiler will generate alternative versions using the required types (where appropriate).

//: ### Generic Functions without constraints
func swap<U,V>( tupleValue : (U, V) ) -> (V, U) {
   let y = (tupleValue.1, tupleValue.0)
   return y
}

swap( (1, "Fred") )


//: ### Generic Functions with constraints
func compareAnything<U:Equatable>(a : U, b : U) -> Bool {
   return a == b
}

compareAnything(10, b: 10)

//: ### Generic Functions with custom constraints
protocol CanMultiply {
   func *(left: Self, right: Self) -> Self
}
extension Double : CanMultiply {}
extension Int : CanMultiply {}
extension Float : CanMultiply {}

func cuboidVolume<T:CanMultiply>(width:T, _ height:T, _ depth:T) -> T {
   return (width*height*depth)
}

cuboidVolume(2.1, 3.1, 4.1)
cuboidVolume(2.1, 3, 4)

