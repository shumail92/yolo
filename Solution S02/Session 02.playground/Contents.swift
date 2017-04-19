//: Playground - noun: a place where people can play
import UIKit

let myName: String = "Shumail Mohyuddin"

// Parameters should have proper names, x1 is maybe not that good of a choice :)
func greet(recipient: String) {
    print("Hello \(recipient)")
}

greet(recipient: myName)
