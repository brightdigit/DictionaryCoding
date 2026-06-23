//
//  DictionaryDecoderImpl+UnboxFloats.swift
//  AtLeast
//
//  Copyright (c) 2026 BrightDigit.
//  All rights reserved.
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
      case let .convertFromString(posInfString, negInfString, nanString) =
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
      case let .convertFromString(posInfString, negInfString, nanString) =
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
