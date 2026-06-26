//
//  DictionaryDecoderImpl+UnboxFloats.swift
//  DictionaryCoding
//
//  Created by Leo Dion.
//  Copyright © 2026 BrightDigit.
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or
//  sell copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//

import Foundation

// MARK: - Float and Double unboxing
extension DictionaryDecoderImpl {
  internal func unbox(_ value: Any, as type: Float.Type) throws -> Float? {
    guard !(value is NSNull) else {
      return nil
    }

    if let number = value as? NSNumber,
      !number.isBool
    {
      return try unboxFloatFromNumber(number, as: type)
    } else if let float = unboxFloatFromString(value, as: type) {
      return float
    }

    throw DecodingError.typeMismatch(
      at: self.codingPath, expectation: type, reality: value
    )
  }

  private func unboxFloatFromNumber(
    _ number: NSNumber,
    as type: Float.Type
  ) throws -> Float {
    let double = number.doubleValue
    guard abs(double) <= Double(Float.greatestFiniteMagnitude) else {
      throw DecodingError.dataCorrupted(
        DecodingError.Context(
          codingPath: self.codingPath,
          debugDescription:
            "Parsed Dictionary number \(number) does not fit in \(type)."
        )
      )
    }
    return Float(double)
  }

  private func unboxFloatFromString(_ value: Any, as type: Float.Type) -> Float? {
    guard let string = value as? String,
      case .convertFromString(let posInfString, let negInfString, let nanString) =
        self.options.nonConformingFloatDecodingStrategy
    else {
      return nil
    }

    if string == posInfString {
      return Float.infinity
    } else if string == negInfString {
      return -Float.infinity
    } else if string == nanString {
      return Float.nan
    }
    return nil
  }

  internal func unbox(_ value: Any, as type: Double.Type) throws -> Double? {
    guard !(value is NSNull) else {
      return nil
    }

    if let number = value as? NSNumber,
      !number.isBool
    {
      return number.doubleValue
    } else if let double = unboxDoubleFromString(value) {
      return double
    }

    throw DecodingError.typeMismatch(
      at: self.codingPath, expectation: type, reality: value
    )
  }

  private func unboxDoubleFromString(_ value: Any) -> Double? {
    guard let string = value as? String,
      case .convertFromString(let posInfString, let negInfString, let nanString) =
        self.options.nonConformingFloatDecodingStrategy
    else {
      return nil
    }

    if string == posInfString {
      return Double.infinity
    } else if string == negInfString {
      return -Double.infinity
    } else if string == nanString {
      return Double.nan
    }
    return nil
  }
}
