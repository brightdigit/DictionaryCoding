//
//  DictionaryDecoderImpl+UnboxIntegers.swift
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

// MARK: - Integer unboxing
extension DictionaryDecoderImpl {
  // On Linux, integer values in [String: Any] may not bridge to NSNumber.
  // swiftlint:disable:next cyclomatic_complexity
  private static func nsNumber(from value: Any) -> NSNumber? {
    // Accept NSNumber directly (e.g. from DictionaryEncoder round-trips)
    // but reject booleans masquerading as integers.
    if let number = value as? NSNumber {
      #if canImport(Darwin)
        // On Darwin, CFBooleanGetTypeID() reliably identifies boolean NSNumbers.
        if number.isBool {
          return nil
        }
      #endif
      // On Linux, Bool and Int8 share objCType "c" so isBool is unreliable;
      // we accept NSNumber as-is and cannot reject boolean-sourced values.
      return number
    }
    // On Linux, native Swift integers in [String: Any] may not bridge to
    // NSNumber automatically — handle each concrete type.
    switch value {
    case let int as Int: return NSNumber(value: int)
    case let int as Int8: return NSNumber(value: int)
    case let int as Int16: return NSNumber(value: int)
    case let int as Int32: return NSNumber(value: int)
    case let int as Int64: return NSNumber(value: int)
    case let uint as UInt: return NSNumber(value: uint)
    case let uint as UInt8: return NSNumber(value: uint)
    case let uint as UInt16: return NSNumber(value: uint)
    case let uint as UInt32: return NSNumber(value: uint)
    case let uint as UInt64: return NSNumber(value: uint)
    default: return nil
    }
  }

  internal func unboxInteger<T: Equatable>(
    _ value: Any,
    as type: T.Type,
    extract: (NSNumber) -> T,
    wrap: (T) -> NSNumber
  ) throws -> T? {
    guard let number = Self.nsNumber(from: value) else {
      throw DecodingError.typeMismatch(
        at: self.codingPath, expectation: type, reality: value
      )
    }

    let result = extract(number)
    guard wrap(result) == number else {
      throw DecodingError.dataCorrupted(
        DecodingError.Context(
          codingPath: self.codingPath,
          debugDescription:
            "Parsed Dictionary number <\(number)> does not fit in \(type)."
        )
      )
    }

    return result
  }

  internal func unbox(_ value: Any, as type: Int.Type) throws -> Int? {
    guard !(value is NSNull) else {
      return nil
    }
    return try unboxInteger(
      value, as: type, extract: { $0.intValue }, wrap: { NSNumber(value: $0) }
    )
  }

  internal func unbox(_ value: Any, as type: Int8.Type) throws -> Int8? {
    guard !(value is NSNull) else {
      return nil
    }
    return try unboxInteger(
      value, as: type, extract: { $0.int8Value }, wrap: { NSNumber(value: $0) }
    )
  }

  internal func unbox(_ value: Any, as type: Int16.Type) throws -> Int16? {
    guard !(value is NSNull) else {
      return nil
    }
    return try unboxInteger(
      value, as: type, extract: { $0.int16Value }, wrap: { NSNumber(value: $0) }
    )
  }

  internal func unbox(_ value: Any, as type: Int32.Type) throws -> Int32? {
    guard !(value is NSNull) else {
      return nil
    }
    return try unboxInteger(
      value, as: type, extract: { $0.int32Value }, wrap: { NSNumber(value: $0) }
    )
  }

  internal func unbox(_ value: Any, as type: Int64.Type) throws -> Int64? {
    guard !(value is NSNull) else {
      return nil
    }
    return try unboxInteger(
      value, as: type, extract: { $0.int64Value }, wrap: { NSNumber(value: $0) }
    )
  }

  internal func unbox(_ value: Any, as type: UInt.Type) throws -> UInt? {
    guard !(value is NSNull) else {
      return nil
    }
    return try unboxInteger(
      value, as: type, extract: { $0.uintValue }, wrap: { NSNumber(value: $0) }
    )
  }

  internal func unbox(_ value: Any, as type: UInt8.Type) throws -> UInt8? {
    guard !(value is NSNull) else {
      return nil
    }
    return try unboxInteger(
      value, as: type, extract: { $0.uint8Value }, wrap: { NSNumber(value: $0) }
    )
  }

  internal func unbox(_ value: Any, as type: UInt16.Type) throws -> UInt16? {
    guard !(value is NSNull) else {
      return nil
    }
    return try unboxInteger(
      value, as: type, extract: { $0.uint16Value }, wrap: { NSNumber(value: $0) }
    )
  }

  internal func unbox(_ value: Any, as type: UInt32.Type) throws -> UInt32? {
    guard !(value is NSNull) else {
      return nil
    }
    return try unboxInteger(
      value, as: type, extract: { $0.uint32Value }, wrap: { NSNumber(value: $0) }
    )
  }

  internal func unbox(_ value: Any, as type: UInt64.Type) throws -> UInt64? {
    guard !(value is NSNull) else {
      return nil
    }
    return try unboxInteger(
      value, as: type, extract: { $0.uint64Value }, wrap: { NSNumber(value: $0) }
    )
  }
}
