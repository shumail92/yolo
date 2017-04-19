//: Playground - noun: a place where people can play
import UIKit

var myName: String = "Dora Dzvonyar"

// Parameters should have proper names, x1 is maybe not that good of a choice :)
func greet(x1: String) {
    print("Hello \(x1)")
}

// Is there any reason to have the following line of code?
let realName: String = myName

greet(x1: myName)
