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

// TASK - Now initialise age (e.g. var age : Int = 20) and try again

/*
This is a safety feature. Using variables before they are initialised can result in bugs that
are hard to track down. We will have more to say about initialisation when we look at structures and classes
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

//Note how data types are objects. Don't worry about this having any impact on the perforamnce of compiled code.
//You can trust the compiler to optimise this

//This is a useful one to know - we've not covered functions yet. String has an initialiser that takes a C-like format string
var strNumber = String(format: "%4.1f", p);
println("The number rounded down is \(strNumber)")



/****************************************
TOPIC 3: Optionals
****************************************/

//If you cannot pre-determine a variable at startup, you can make a variable optional.
//Such variables are actually enumerated types (Swift has quite advanved enumerated types - we will meet these later)
var dayBabyIsBorn : Int?    //THIS IS NOT AN Int - it "wraps" an Int inside an enumerated type

//When ready, we can assign this variable
dayBabyIsBorn = 28

//When we try to access the value, you can "force upwrap" it using the pling "!"
let day : Int = dayBabyIsBorn!
// Question - What happens when you remove the exclaimation mark?
// Question - What happens when you don't initialise dayBabyIsBorn?

//Forced unwrapping of nil will result in a run-time crash.
//Forced unwrapping is best avoided where possible unless you are very sure it is safe to do so.
//The force-unwrap operator is a pling ! - this usually represents danger. The same applies to Swift code.
//If you are looking for a run-time crash in your code, look for the ! operators

//A safer alternative - "nil coalescing operator": unwrap if not nil, otherwise set to a literal or another non-optional variable
let d : Int = dayBabyIsBorn ?? 0

//This is fine when it makes sense to have an alternative value, but this is not always the case.

//Even better / more generic, use "if let" - this tests the value for nil before unwrapping.
if let dy = dayBabyIsBorn {
    //This ONLY runs if dayBabyIsBorn can be safely unwrapped (once the baby has been born presumably!)
    println("Day baby is born is \(dy)th of the month")
}

//You can achieve the same this way (not as nice) as an optional without a value can be compared to nil
if dayBabyIsBorn != nil {
    println("Day baby is born is \(dayBabyIsBorn!)th of the month")
}


// ** Implicitly unwrapped optionals **

//There are some use-cases where a variable needs to be optional, but where we know it becomes initialised
//and is always safe to use. 
//An example is an Outlet, where at run-time it is hooked up to an object in memory by the nib loading mechansim.
//The point at which we, the developers can access the outlets, they are already hooked up.
//In such cases, you can use implicitly wrapped variables to make code look prettier, but it's not just about prettyness.
//The absence of a ! operator means this is probably not code responsible for a run-time error.


var petWeight : Double!     //This is an optional

//petWeight is assigned a value at some point before we access it code
petWeight = 3.5

//It is therefore to safe access it. You do not need the ! to unwrap
let w : Double = petWeight
println("w = \(w)")

//Be warned - do not use implicitly unwrapped optionals unless you are very sure they fit this use-case.
// Question - comment out the line that initialises petWeight with 3.5 - what happens?


//Optional chaining

//Consider the tasks of converting a string into a Double. 
//One of the dangers is that the string is not a properly formatted number - so how should a conversion function communicate this?
//Optionals are often returned from functions that can potentially fail.

//I am going to use the class NSNumberFormatter - don't worry about the details of this.
// It has a method called numberFromString() which returns an optional (wrapped instance of the NSNumber class)
// If a conversion can be done, a wrapped instance of NSNumber object is returned. 
// NSNumber has a method doubleValue() to convert to a Double.

let strCandidate1 = "1.2345"    //This can convert
let strCandidate2 = "ten"       //This cannot

//The value I will store in is an optional type - this is because it might be nil (indicating a failure to convert)
var dblVal : Double?

//First time, all is well - note the ? in the next line
dblVal = NSNumberFormatter().numberFromString(strCandidate1)?.doubleValue
if let v = dblVal {
    //dbVal can be unwrapped and copied into v
    println("The number is \(v)")
}

// If numberFromString() cannot perform the conversion, a nil is returned. Let's look at this now

//Second time, the string is not a valid number - the evaluation gets as far as NSNumberFormatter().numberFromString(strCandidate2)
dblVal = NSNumberFormatter().numberFromString(strCandidate2)?.doubleValue
//The ? above tells the compiler to only continue evauation if the result can be safely unwrapped, otherwise stop processing
//We now conditionally unwrap using "if let"
if let v = dblVal {
    //dblVal cannot be unwrapped - so this code never runs
    println("The number is \(v)")
}
//Note that nothing was output as the return value of numberFromString cannot be safely unwrapped


/***********************************************
TOPIC 4: Reference-Type and Value-Type Semantics
***********************************************/

//We are familiar with value-type semantics when working with simple data types. For example:
var fred : Int = 10
var jim : Int = fred
jim++
// The variable jim is an indepdnent copy - so changes to jim will not impact on fred
if (fred == jim) {
    println("These must be the same object");
} else {
    println("These must be indepdnent objects");
}


//Let's now look at a Swift Array
var arrayOfStrings : [String] = ["Mars", "Jupiter", "Earth"]
var arrayOfMoreStrings : [String] = arrayOfStrings          //This will perform a (mutable) deep copy (see **footnote)
//We can compare them (later, we discuss protocols and types of objects that are Equatable)
if (arrayOfStrings == arrayOfMoreStrings) {
    println("These arrays are identical in content")
} else {
    println("These arrays are different")
}
//Let's add one more the second array
arrayOfMoreStrings.append("Naboo")

//Compare
arrayOfStrings
arrayOfMoreStrings
if (arrayOfStrings == arrayOfMoreStrings) {
    println("These arrays are still identical in content")
} else {
    println("These arrays are now different")
}

//**footnote - for efficiency, a copy is only actually made if one of the arrays is modified - read up on "copy on write" if you are curious


//Note how they are indepednent? This is because they use value semantics. Structures and enumerated types are value types.
//Instances of classes and classes themselves are reference types.

//Let's now compare this with class NSArray. An instance of a class is always a reference type.
//NSArray is a class that contains a orded list of objects.
var xx : NSMutableArray = NSMutableArray(arrayLiteral: 10, "Freddy", 20.0)
//Note let's equate this to another
var yy : NSMutableArray = xx

//First - by content
if (xx == yy) {
   println("These arrays are identical in content")
} else {
   println("These arrays are different")
}
//Second - we can also comare the references themselves using the === operator
if (xx === yy) {
    println("These variables reference the exact same object")
} else {
    println("These variables reference different objects")
}


//Mutate the contents of yy, but don't (progamatically) change xx
yy[0] = 99

//Let's compare again
//First - by content
if (xx == yy) {
    println("These arrays are identical in content")
} else {
    println("These arrays are different")
}
//Second - we can also comare the references themselves using the === operator
if (xx === yy) {
    println("These variables reference the exact same object")
} else {
    println("These variables reference different objects")
}

//We see both are modified. This demonstrates reference-type semantics. This is expected as NSArray is a class

//Now I create an independent array that happens to have the same content
var zz : NSMutableArray = NSMutableArray(arrayLiteral: 99, "Freddy", 20.0)
if (xx == zz) {
    println("These arrays are identical in content")
} else {
    println("These arrays are different")
}
if (xx === zz) {
    println("These variables reference the exact same object")
} else {
    println("These variables reference different objects")
}
//This time, == indicates the content is the same, but === indicates these are indepednent references


//Problems might occur when reading code, and where you are unsure whether an object is a reference type or value type. 
//It might be an idea to use a naming convention for reference objects?













