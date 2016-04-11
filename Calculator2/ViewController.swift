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
   @IBOutlet weak var commandHistory: UILabel!

   var userIsInTheMiddleOfTypingANumber = false

   // Indicates if a decimal is already used
   var isDecimalSpecified = false
   
   @IBAction func appendDigit(sender: UIButton) {
      let digit = sender.currentTitle!

      if userIsInTheMiddleOfTypingANumber {

         if ( digit != "." || ( digit == "." && !isDecimalSpecified ) ) {

            // Append display with a pressed digit
            display.text = display.text! + digit

            // Decimal was appended, don't append any other decimals:
            if digit == "." {
               isDecimalSpecified = true
            }
         }

      }

      else {

         // Preserve 0 if typing a decimal:
         if digit == "." {
            display.text = "0" + digit
            isDecimalSpecified = true
         }
         else {
            display.text = digit
         }

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
      case "sin()": performOperation { sin($0) }
      case "cos()": performOperation { cos($0) }
      case "π": addConstantToStack(M_PI)
      default: break
      }

      // Save to the command history
      commandHistory.sizeToFit()
      commandHistory.text = commandHistory.text! + "\n\(operation)"
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

   func addConstantToStack(constant: Double) {
      displayValue = constant
      enter()
   }

   @IBAction func clear() {
      display.text = "0"
      operandStack.removeAll()
      commandHistory.text = ""
      userIsInTheMiddleOfTypingANumber = false
      isDecimalSpecified = false
   }

   @IBAction func enter() {

      if userIsInTheMiddleOfTypingANumber {

         // Save to the command history
         commandHistory.sizeToFit()
         commandHistory.text = commandHistory.text! + "\n\(display.text!)"

      }

      userIsInTheMiddleOfTypingANumber = false
      isDecimalSpecified = false
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

