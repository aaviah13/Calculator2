//
//  ViewController.swift
//  Calculator2
//
//  Created by David Hsu on 4/9/16.
//  Copyright © 2016 David Hsu. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
   @IBOutlet weak var display: UILabel!
   @IBOutlet weak var commandHistory: UILabel!

   var userIsInTheMiddleOfTypingANumber = false

   var brain = CalculatorBrain()

   // Indicates if a decimal is already used
   var isDecimalSpecified = false
   
   @IBAction func appendDigit(sender: UIButton)
   {
      let digit = sender.currentTitle!

      if userIsInTheMiddleOfTypingANumber
      {
         if ( digit != "." || ( digit == "." && !isDecimalSpecified ) )
         {
            // Append display with a pressed digit
            display.text = display.text! + digit

            // Decimal was appended, don't append any other decimals:
            if digit == "." {
               isDecimalSpecified = true
            }
         }
      }

      else
      {
         // Preserve 0 if typing a decimal:
         if digit == "."
         {
            display.text = "0" + digit
            isDecimalSpecified = true
         }
         else
         {
            display.text = digit
         }

         userIsInTheMiddleOfTypingANumber = true
      }
   }

   @IBAction func operate(sender: UIButton)
   {
      // Auto-enter when using an operator
      if userIsInTheMiddleOfTypingANumber {
         enter()
      }

      if let operation = sender.currentTitle
      {
         if let result = brain.performOperation(operation)
         {
            displayValue = result
            commandHistory.text = commandHistory.text! + "\n\(operation)"
         }
         else
         {
            displayValue = 0
         }
      }
   }

   @IBAction func clear()
   {
      display.text = "0"
      commandHistory.text = ""
      brain.clearStack()
      userIsInTheMiddleOfTypingANumber = false
      isDecimalSpecified = false
   }

   @IBAction func enter()
   {
      if userIsInTheMiddleOfTypingANumber
      {
         // Save to the command history
         commandHistory.sizeToFit()
         commandHistory.text = commandHistory.text! + "\n\(display.text!)"

      }

      userIsInTheMiddleOfTypingANumber = false
      isDecimalSpecified = false

      if let result = brain.pushOperand(displayValue)
      {
         displayValue = result
      }
      else
      {
         // If result is optional...
         displayValue = 0
      }
   }

   var displayValue: Double
      {
      get
      {
         // TODO: Look up NSNumberFormatter
         return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
      }

      set
      {
         display.text = "\(newValue)"
         userIsInTheMiddleOfTypingANumber = false
      }
   }
}

