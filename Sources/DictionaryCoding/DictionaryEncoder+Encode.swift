//
//  DictionaryEncoder+Encode.swift
//  AtLeast
//
//  Copyright (c) 2026 BrightDigit.
//  All rights reserved.
//

import Foundation

extension DictionaryEncoder {
  /// Encodes the given top-level value and returns its Dictionary representation.
  ///
  /// - parameter value: The value to encode.
  /// - returns: A new `NSDictionary` value containing the encoded Dictionary data.
  /// - throws: `EncodingError.invalidValue` if a non-conforming floating-point value
  ///   is encountered during encoding, and the encoding strategy is `.throw`.
  /// - throws: An error if any value throws an error during encoding.
  public func encode<T: Encodable>(_ value: T) throws -> NSDictionary {
    let topLevel = try encodeToTopLevel(value)

    guard let dict = topLevel as? NSDictionary else {
      throw EncodingError.invalidValue(
        value,
        EncodingError.Context(
          codingPath: [],
          debugDescription:
            "Top-level \(T.self) did not encode as a dictionary."
        )
      )
    }
    return dict
  }

  /// Encodes the given top-level value and returns its Dictionary representation.
  ///
  /// - parameter value: The value to encode.
  /// - returns: A new `[String: Any]` value containing the encoded Dictionary data.
  /// - throws: `EncodingError.invalidValue` if a non-conforming floating-point value
  ///   is encountered during encoding, and the encoding strategy is `.throw`.
  /// - throws: An error if any value throws an error during encoding.
  public func encode<T: Encodable>(_ value: T) throws -> [String: Any] {
    let topLevel = try encodeToTopLevel(value)

    guard let dict = topLevel as? [String: Any] else {
      throw EncodingError.invalidValue(
        value,
        EncodingError.Context(
          codingPath: [],
          debugDescription:
            "Top-level \(T.self) did not encode as a dictionary."
        )
      )
    }
    return dict
  }

  private func encodeToTopLevel<T: Encodable>(_ value: T) throws -> Any {
    let encoder = DictionaryEncoderImpl(options: self.options)

    guard let topLevel = try encoder.boxEncodable(value) else {
      throw EncodingError.invalidValue(
        value,
        EncodingError.Context(
          codingPath: [],
          debugDescription: "Top-level \(T.self) did not encode any values."
        )
      )
    }

    try validateTopLevelFragment(value, topLevel: topLevel)
    return topLevel
  }

  private func validateTopLevelFragment<T: Encodable>(
    _ value: T,
    topLevel: Any
  ) throws {
    if topLevel is NSNull {
      throw EncodingError.invalidValue(
        value,
        EncodingError.Context(
          codingPath: [],
          debugDescription:
            "Top-level \(T.self) encoded as null Dictionary fragment."
        )
      )
    } else if topLevel is NSNumber {
      throw EncodingError.invalidValue(
        value,
        EncodingError.Context(
          codingPath: [],
          debugDescription:
            "Top-level \(T.self) encoded as number Dictionary fragment."
        )
      )
    } else if topLevel is NSString {
      throw EncodingError.invalidValue(
        value,
        EncodingError.Context(
          codingPath: [],
          debugDescription:
            "Top-level \(T.self) encoded as string Dictionary fragment."
        )
      )
    }
  }
}
