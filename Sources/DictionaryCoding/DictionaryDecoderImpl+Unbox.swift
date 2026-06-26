//
//  DictionaryDecoderImpl+Unbox.swift
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

// MARK: - Concrete Value Representations
extension DictionaryDecoderImpl {
  internal func unbox(_ value: Any, as type: Bool.Type) throws -> Bool? {
    guard !(value is NSNull) else {
      return nil
    }

    if let number = value as? NSNumber {
      if number.isBool {
        return number.boolValue
      } else {
        return number != 0
      }
    }

    throw DecodingError.typeMismatch(
      at: self.codingPath, expectation: type, reality: value
    )
  }

  internal func unbox(_ value: Any, as type: String.Type) throws -> String? {
    guard !(value is NSNull) else {
      return nil
    }

    if let url = value as? URL {
      return url.absoluteString
    }

    if let uuid = value as? UUID {
      return uuid.uuidString
    }

    guard let string = value as? String else {
      throw DecodingError.typeMismatch(
        at: self.codingPath, expectation: type, reality: value
      )
    }

    return string
  }

  internal func unbox(_ value: Any, as type: UUID.Type) throws -> UUID? {
    guard !(value is NSNull) else {
      return nil
    }

    if let uuid = value as? UUID {
      return uuid
    }

    if let string = value as? String {
      return UUID(uuidString: string)
    }

    // NB this could be dangerous - we're assuming that it's ok to call
    // CFGetTypeID with the value, which may not be true
    #if canImport(Darwin)
      let cfType = CFGetTypeID(value as CFTypeRef)
      if cfType == CFUUIDGetTypeID() {
        let cfValue = unsafeBitCast(value as CFTypeRef, to: CFUUID.self)
        let string = CFUUIDCreateString(kCFAllocatorDefault, cfValue) as String
        return UUID(uuidString: string)
      }
    #endif

    throw DecodingError.typeMismatch(
      at: self.codingPath, expectation: type, reality: value
    )
  }

  internal func unbox(_ value: Any, as type: Decimal.Type) throws -> Decimal? {
    guard !(value is NSNull) else {
      return nil
    }

    if let decimal = value as? Decimal {
      return decimal
    } else if let decimalNumber = value as? NSDecimalNumber {
      // On Linux, NSDecimalNumber may not auto-bridge to Decimal.
      return decimalNumber as Decimal
    } else {
      guard let doubleValue = try self.unbox(value, as: Double.self) else {
        return nil
      }
      return Decimal(doubleValue)
    }
  }
}
