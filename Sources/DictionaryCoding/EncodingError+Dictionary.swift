//
//  EncodingError+Dictionary.swift
//  AtLeast
//
//  Copyright (c) 2026 BrightDigit.
//  All rights reserved.
//

import Foundation

extension EncodingError {
  /// Returns a `.invalidValue` error describing the given invalid floating-point value.
  ///
  /// - parameter value: The value that was invalid to encode.
  /// - parameter path: The path of `CodingKey`s taken to encode this value.
  /// - returns: An `EncodingError` with the appropriate path and debug description.
  internal static func invalidFloatingPointValue<T: FloatingPoint>(
    _ value: T,
    at codingPath: [CodingKey]
  ) -> EncodingError {
    let valueDescription: String
    if value == T.infinity {
      valueDescription = "\(T.self).infinity"
    } else if value == -T.infinity {
      valueDescription = "-\(T.self).infinity"
    } else {
      valueDescription = "\(T.self).nan"
    }

    let debugDescription =
      "Unable to encode \(valueDescription) directly in Dictionary. "
      + "Use DictionaryEncoder.NonConformingFloatEncodingStrategy"
      + ".convertToString to specify how the value should be encoded."
    return .invalidValue(
      value,
      EncodingError.Context(
        codingPath: codingPath,
        debugDescription: debugDescription
      )
    )
  }
}
