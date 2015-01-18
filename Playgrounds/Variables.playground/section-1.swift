/* *************************
    Playground on Variables
   *************************
*/

import UIKit

/***************************************
TOPIC 1: Mutable and Immutable Variables
****************************************/

//Variable declaration - one with var, another with let
// var is mutable
// let is immutable
var str1 : String = "Hello, playground"
let str2 : String = "Hello, playground"

//Try uncommenting the following two lines - can you predict which will work?
//str1 = str1 + "!"
//str2 = str2 + "!"

println("string 1: \(str1)")
println("string 1: \(str2)")

//Note also that the operator + has been overloaded to join strings...which is nice.



/***************************************
TOPIC 2: Initialisation
****************************************/

//For safely, variables cannot be used until they are initialised.

//This variable is strongly types, but uninitialised
var age : Int

//What do you think will happen if you uncomment this line?
//let y = age

// TASK - Now initialise age and try again

/*
This is a safety feature. Using variables before they are initialised can result in bugs that
are hard to track down. 
We will have more to say about initialisation when we look at structures and classes
*/

/***************************************
TOPIC 3: Type Safety
****************************************/
let p : Double = 10.1234567890123

//Try uncommenting this line
//var fVal : Float = p

//You cannot simply equate variables of different types.

//The next line creates a new Float with p passed to it's constructor
//Yes, all datatypes are objects!
var fVal : Float = Float(p)             //This will loose precision

var iVal : Int = Int(floor(p + 0.5))    //This performs a round then a conversion

//Note how data types are objects. 
//Don't worry about this having any impact on the perforamnce of compiled code.
//You can trust the compiler to optimise this

//This is a useful one to know
var strNumber = String(format: "%4.1f", p);
println("The number rounded down is \(strNumber)")



/****************************************
TOPIC 3: Optionals
****************************************/
//If you cannot pre-determine a variable at startup, you can make a variable optional.
//Such variables are enumerated types (Swift has quite advanved enumerated types)
var dayBabyIsBorn : Int?    //THIS IS NOT AN Int - it "wraps" an Int inside an enumerated type

//When ready, we can assign this variable
dayBabyIsBorn = 28

//When we try to access the value, you can "force upwrap" it using the pling "!"
let day : Int = dayBabyIsBorn!
// Question - What happens when you remove the exclaimation mark?
// Question - What happens when you don't assign a value to dayBabyIsBorn?

//Forced unwrapping of nil will result in a run-time crash.
//Forced unwrapping is best avoided where possible unless you are very sure it is safe to do so.

//A safer alternative - "nil coalescing operator": unwrap if not nil, otherwise set to a literal or another non-optional variable
let d : Int = dayBabyIsBorn ?? 0

//This is fine when it makes sense to have an alternative value. This is not always the case.

//Even better / more generic, use "if let" - this tests the value for nil before unwrapping.
if let dy = dayBabyIsBorn {
    //This ONLY runs if dayBabyIsBorn can be safely unwrapped.
    println("Day baby is born is \(dy)th of the month")
}

//You can achieve the same this way
if dayBabyIsBorn != nil {
    println("Day baby is born is \(dayBabyIsBorn!)th of the month")
}


// ** Implicitly unwrapped optionals **

//There are some use-cases where a variable needs to be optional, but where we know it becomes initialised
//and is always safe to use. An example is an Outlet, where at run-time it is hooked up to an object in memory by the nib loading mechansim.
//In such cases, you can use implicitly wrapped variables
var petWeight : Double!

//petWeight is assigned a value at some point before we access it code
petWeight = 3.5

let w : Double = petWeight


//Optional chaining

//Consider the tasks of converting a string into a Double. Of of the dangers is that the string is not a properly formatted number
//Optionals are often returned from functions that can potentially fail.

//I am going to use the class NSNumberFormatter
//It has a method called numberFromString() which returns an optional (wrapped associated type is NSNumber)
// If a conversion can be done, a wrapped NSNumber object is returned. This is then converted to a Double with the doubleValue() method
// If a conversion cannot be done, nil is returned and no more processing is done.

let strCandidate1 = "1.2345"    //This can convert
let strCandidate2 = "ten"       //This cannot

//The value I will store in is an optional type - this is because it might be nil
var dblVal : Double?

//First time, all is well
dblVal = NSNumberFormatter().numberFromString(strCandidate1)?.doubleValue
if let v = dblVal {
    //dbVal can be unwrapped and copied into v
    println("The number is \(v)")
}

//Second time, the string is not a valid number - the evaluation gets as far as NSNumberFormatter().numberFromString(strCandidate2)
//The ? tells the compiler to only continue evauation if the result can be safely unwrapped, otherwise stop processing
dblVal = NSNumberFormatter().numberFromString(strCandidate2)?.doubleValue
if let v = dblVal {
    //dblVal cannot be unwrapped - so this code never runs
    println("The number is \(v)")
}
//Note that nothing was output as the return value of numberFromString cannot be safely unwrapped
//
// I've avoided the force-unwrap operator ! in all cases
// Remember.....
//                              pling ! = DANGER
//


/***********************************************
TOPIC 4: Reference-Type and Value-Type Semantics
***********************************************/

//We are familiar with value-type semantics when working with simple data types. For example:
var fred : Int = 10
var jim : Int = fred
jim++
// The variable jim is an indepdnent copy - so changes to jim will not impact on fred
println("fred = \(fred)")
println("jim = \(jim)")

//Let's now look at an Array
var arrayOfStrings : [String] = ["Mars", "Jupiter", "Earth"]
var arrayOfMoreStrings : [String] = arrayOfStrings

//Let's add one more the second array
arrayOfMoreStrings.append("Naboo")

//Compare
arrayOfStrings
arrayOfMoreStrings

//Note how they are indepednent? This is different from equating two objects of type NSArray*
//The array is behaving as a value-type

//Let's now compare this with NSArray
var xx : NSMutableArray = NSMutableArray(arrayLiteral: 10, "Freddy", 20.0)
var yy : NSMutableArray = xx

//Update the contens of yy
yy.addObject("Brian")

//We see both are modified. This demonstrates reference-type semantics. This is expected as NSArray is a class
xx
yy

//Problems might occur if you are unsure which is being used. It might be an idea to use a naming convention for objects





