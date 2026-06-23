//
//  DecodingError+Dictionary.swift
//  AtLeast
//
//  Copyright (c) 2026 BrightDigit.
//  All rights reserved.
//

import Foundation

extension DecodingError {
  /// Returns a `.typeMismatch` error describing the expected type.
  ///
  /// - parameter path: The path of `CodingKey`s taken to decode a value of this type.
  /// - parameter expectation: The type expected to be encountered.
  /// - parameter reality: The value that was encountered instead of the expected type.
  /// - returns: A `DecodingError` with the appropriate path and debug description.
  internal static func typeMismatch(
    at path: [CodingKey],
    expectation: Any.Type,
    reality: Any
  ) -> DecodingError {
    let description =
      "Expected to decode \(expectation) "
      + "but found \(typeDescription(of: reality)) instead."
    return .typeMismatch(
      expectation,
      Context(codingPath: path, debugDescription: description)
    )
  }

  /// Returns a description of the type of `value` appropriate for an error message.
  ///
  /// - parameter value: The value whose type to describe.
  /// - returns: A string describing `value`.
  internal static func typeDescription(of value: Any) -> String {
    if value is NSNull {
      "a null value"
    } else if value is NSNumber {
      "a number"
    } else if value is String {
      "a string/data"
    } else if value is [Any] {
      "an array"
    } else if value is [String: Any] {
      "a dictionary"
    } else {
      "\(type(of: value))"
    }
  }
}
