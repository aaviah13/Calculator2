//
//  ViewController.swift
//  Calculator2
//
//  Created by David Hsu on 4/9/16.
//  Copyright © 2016 David Hsu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

   @IBOutlet weak var display: UILabel!

   var userIsInTheMiddleOfTypingANumber = false

   @IBAction func appendDigit(sender: UIButton) {
       let digit = sender.currentTitle!

      if userIsInTheMiddleOfTypingANumber {

         // Append display with a pressed digit
         display.text = display.text! + digit

      }
      else {
         display.text = digit
         userIsInTheMiddleOfTypingANumber = true
      }

   }

   var operandStack = Array<Double>()

   @IBAction func operate(sender: UIButton) {
      let operation = sender.currentTitle!

      // Auto-enter when using an operator
      if userIsInTheMiddleOfTypingANumber {
         enter()
      }

      switch operation {
      case "×": performOperation { $0 * $1 }
      case "÷": performOperation { $1 / $0 }
      case "+": performOperation { $0 + $1 }
      case "−": performOperation { $1 - $0 }
      case "√": performOperation { sqrt($0) }
      default: break
      }
   }

   func performOperation(operation: (Double, Double) -> Double) {
      if operandStack.count >= 2 {
         displayValue = operation(operandStack.removeLast(), operandStack.removeLast())
         enter()
      }
   }

   // Objective-C doesn't like overloaded functions, when using UIViewController
   // Need to specify this is non-objective-C
   @nonobjc
   func performOperation(operation: Double -> Double) {
      if operandStack.count >= 1 {
         displayValue = operation(operandStack.removeLast())
         enter()
      }
   }

   @IBAction func enter() {
      userIsInTheMiddleOfTypingANumber = false
      operandStack.append(displayValue)
      print("Operand = \(operandStack)")
   }

   var displayValue: Double {
      get {
         // TODO: Look up NSNumberFormatter
         return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
      }

      set {
         display.text = "\(newValue)"
         userIsInTheMiddleOfTypingANumber = false
      }

   }

}

