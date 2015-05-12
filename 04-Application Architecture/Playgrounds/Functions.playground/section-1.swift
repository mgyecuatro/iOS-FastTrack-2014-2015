

import UIKit

func timeNow(Void) -> String {
    
    let date = NSDate()
    let fmt = NSDateFormatter()
    fmt.dateFormat = "h:mm a"
    let desc = fmt.stringFromDate(date)
    
    return desc
}

let t = timeNow()
println("The time is \(t)")

func displayTimeWithFormat(formatString : String) {
    if (formatString.isEmpty) {
        return
    }
    let date = NSDate()
    let fmt = NSDateFormatter()
    fmt.dateFormat = formatString
    let desc = fmt.stringFromDate(date)
    println("\(desc)")
}


displayTimeWithFormat("d MMMM YYYY")


let theDate : (String, Int) = ("January", 30)

let (month, day) = theDate

println("It is day \(day) in the month of \(month)")
let (mm, _) = theDate

println("Month = \(mm)")


func currentDate() -> (day:Int, month:String, year:Int)
{
    let date = NSDate() //Now
    
    //Get month as a string
    let fmt = NSDateFormatter()
    fmt.dateFormat = "MMMM"
    let monthString = fmt.stringFromDate(date)

    //I am *very* confident the following will not return nil
    let cal : NSCalendar! =
            NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
    
    //Extract the day and year as Int values
    let d  = cal.component(NSCalendarUnit.DayCalendarUnit, fromDate: date)
    let y  = cal.component(NSCalendarUnit.YearCalendarUnit, fromDate: date)
    
    //Return result as 3-tuple
    return (day:d, month:monthString, year:y)
}

let (d,m,y) = currentDate()
println("On day \(d) of \(month), in the year \(y), Xcode 6.3 beta was updated")





func cuboidVolume(#width :Double, #height:Double, #depth:Double) -> Double {
    return width * height * depth
}

let vol = cuboidVolume(width: 2.0, height: 3.0, depth: 10.0)



func bmi(#weight : Double, #height : Double) -> Double {
    return weight / (height*height)
}

bmi(weight: 80.5, height: 1.85)

func bmi_curry(height : Double) -> (Double -> Double)? {
    func calc_bmi(weight : Double) -> Double {
        //Capture the argument of the enclosing function
        let h = height
        return weight / (h*h)
    }
    
    return calc_bmi
}

if let bmidx = bmi_curry(1.8)?(90.0) {
    println("bmi = \(bmidx)")
}

