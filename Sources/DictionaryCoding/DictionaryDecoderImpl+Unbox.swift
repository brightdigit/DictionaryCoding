//
//  DictionaryDecoderImpl+Unbox.swift
//  AtLeast
//
//  Copyright (c) 2026 BrightDigit.
//  All rights reserved.
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
