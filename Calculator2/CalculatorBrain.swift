//
//  CalculatorBrain.swift
//  Calculator2
//
//  Created by David Hsu on 4/10/16.
//  Copyright © 2016 David Hsu. All rights reserved.
//

import Foundation

class CalculatorBrain
{
   // CustomStringConvertible is a protocol
   private enum Op: CustomStringConvertible
   {
      case Operand(Double)
      case UnaryOperation(String, Double -> Double)
      case BinaryOperation(String, (Double, Double) -> Double)
      case Constant(String, Double)

      // Specific name "description" for printing out enum
      var description: String
         {
         get {
            switch self
            {
            case .Operand(let operand):
               return "\(operand)"
            case .UnaryOperation(let symbol, _):
               return symbol
            case .BinaryOperation(let symbol, _):
               return symbol
            case .Constant(let constant, _):
               return constant
            }
         }
      }
   }

   // Same as var opStack = Array<Op>()
   private var opStack = [Op]()

   // Same as var knownOps = Dictionary<String, Op>()
   private var knownOps = [String:Op]()

   private var knownConstants = [String:Op]()

   // Constructor
   init()
   {
      func learnOp(op: Op)
      {
         knownOps[op.description] = op
      }

      func learnConstant(op: Op)
      {
         knownConstants[op.description] = op
      }

      // Add operators to the dictionary
      learnOp(Op.BinaryOperation("×", *))
      learnOp(Op.BinaryOperation("÷") { $1 / $0 })
      learnOp(Op.BinaryOperation("+", +))
      learnOp(Op.BinaryOperation("-") { $1 - $0 })
      learnOp(Op.UnaryOperation("√", sqrt))
      learnOp(Op.UnaryOperation("sin()") { sin($0) })
      learnOp(Op.UnaryOperation("cos()") { cos($0) })

      // Add constants to the constants dictionary
      learnConstant(Op.Constant("π", M_PI))
   }

   // Structs passed by value, classes passed by reference
   private func evaluate(ops: [Op]) -> (result: Double?, remainingOps: [Op])
   {
      if !ops.isEmpty {
         var remainingOps = ops
         let op = remainingOps.removeLast()

         switch op {
         case .Operand(let operand):
            return (operand, remainingOps)

         // "operation" is the actual function of the operation
         case .UnaryOperation(_, let operation):

            // Recursively evaluate to get operands
            let operandEvaluation = evaluate(remainingOps)

            if let operand = operandEvaluation.result
            {
               return (operation(operand), operandEvaluation.remainingOps)
            }

         case .BinaryOperation(_, let operation):

            let op1Evaluation = evaluate(remainingOps)

            if let operand1 = op1Evaluation.result
            {
               let op2Evaluation = evaluate(op1Evaluation.remainingOps)

               if let operand2 = op2Evaluation.result
               {
                  return (operation(operand1, operand2), op2Evaluation.remainingOps)
               }
            }

         case .Constant(_, let constant):
            return (constant, remainingOps)
         }
      }
      return (nil, ops)
   }

   // Returns optional Double since user could use evaluate without any operands
   func evaluate() -> Double?
   {
      let (result, remainder) = evaluate(opStack)
      print("\(opStack) = \(result) with \(remainder) left over")
      return result
   }

   func pushOperand(operand: Double) -> Double?
   {
      opStack.append(Op.Operand(operand))
      return evaluate()
   }

   func performOperation(symbol: String) -> Double?
   {
      // operation is an Optional op (dictionaries always return optionals)
      if let operation = knownOps[symbol]
      {
         opStack.append(operation)
      }
      // If operation wasn't found, check if it's a constant:
      else if let constant = knownConstants[symbol]
      {
         opStack.append(constant)
      }
      return evaluate()
   }

   func clearStack()
   {
      opStack.removeAll()
   }
}