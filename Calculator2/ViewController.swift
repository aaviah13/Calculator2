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

