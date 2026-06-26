//
//  DictionaryEncoder.swift
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

// ===----------------------------------------------------------------------===//
// Dictionary Encoder
// ===----------------------------------------------------------------------===//

/// `DictionaryEncoder` facilitates the encoding of `Encodable` values into Dictionary.
open class DictionaryEncoder {
  // MARK: - Subtypes

  /// The strategy to use for encoding `Date` values.
  public enum DateEncodingStrategy {
    /// Defer to `Date` for choosing an encoding. This is the default strategy.
    case deferredToDate

    /// Encode the `Date` as a UNIX timestamp (as a Dictionary number).
    case secondsSince1970

    /// Encode the `Date` as UNIX millisecond timestamp (as a Dictionary number).
    case millisecondsSince1970

    /// Encode the `Date` as an ISO-8601-formatted string (in RFC 3339 format).
    @available(OSX 10.12, iOS 10.0, watchOS 3.0, tvOS 10.0, *)
    case iso8601

    /// Encode the `Date` as a string formatted by the given formatter.
    case formatted(DateFormatter)

    /// Encode the `Date` as a custom value encoded by the given closure.
    ///
    /// If the closure fails to encode a value into the given encoder, the encoder
    /// will encode an empty automatic container in its place.
    case custom((Date, Encoder) throws -> Void)
  }

  /// The strategy to use for encoding `Data` values.
  public enum DataEncodingStrategy {
    /// Defer to `Data` for choosing an encoding.
    case deferredToData

    /// Encoded the `Data` as a Base64-encoded string. This is the default strategy.
    case base64

    /// Encode the `Data` as a custom value encoded by the given closure.
    ///
    /// If the closure fails to encode a value into the given encoder, the encoder
    /// will encode an empty automatic container in its place.
    case custom((Data, Encoder) throws -> Void)
  }

  /// The strategy to use for non-Dictionary-conforming floating-point values
  /// (IEEE 754 infinity and NaN).
  public enum NonConformingFloatEncodingStrategy {
    /// Throw upon encountering non-conforming values. This is the default strategy.
    case `throw`

    /// Encode the values using the given representation strings.
    case convertToString(positiveInfinity: String, negativeInfinity: String, nan: String)
  }

  /// The strategy to use for automatically changing the value of keys before encoding.
  public enum KeyEncodingStrategy {
    /// Use the keys specified by each type. This is the default strategy.
    case useDefaultKeys

    /// Convert from "camelCaseKeys" to "snake_case_keys" before writing a key
    /// to Dictionary payload.
    ///
    /// Capital characters are determined by testing membership in
    /// `CharacterSet.uppercaseLetters` and `CharacterSet.lowercaseLetters`
    /// (Unicode General Categories Lu and Lt).
    /// The conversion to lower case uses `Locale.system`, also known as the ICU
    /// "root" locale. This means the result is consistent regardless of the current
    /// user's locale and language preferences.
    ///
    /// Converting from camel case to snake case:
    /// 1. Splits words at the boundary of lower-case to upper-case
    /// 2. Inserts `_` between words
    /// 3. Lowercases the entire string
    /// 4. Preserves starting and ending `_`.
    ///
    /// For example, `oneTwoThree` becomes `one_two_three`.
    /// `_oneTwoThree_` becomes `_one_two_three_`.
    ///
    /// - Note: Using a key encoding strategy has a nominal performance cost,
    ///   as each string key has to be converted.
    case convertToSnakeCase

    /// Provide a custom conversion to the key in the encoded Dictionary from the keys
    /// specified by the encoded types.
    /// The full path to the current encoding position is provided for context
    /// (in case you need to locate this key within the payload).
    /// The returned key is used in place of the last component in the coding path
    /// before encoding.
    /// If the result of the conversion is a duplicate key, then only one value will
    /// be present in the result.
    case custom((_ codingPath: [CodingKey]) -> CodingKey)
  }

  // MARK: - Instance Properties

  /// The strategy to use in encoding dates.
  ///
  /// Defaults to `.deferredToDate`.
  open var dateEncodingStrategy: DateEncodingStrategy = .deferredToDate

  /// The strategy to use in encoding binary data.
  ///
  /// Defaults to `.base64`.
  open var dataEncodingStrategy: DataEncodingStrategy = .base64

  /// The strategy to use in encoding non-conforming numbers.
  ///
  /// Defaults to `.throw`.
  open var nonConformingFloatEncodingStrategy: NonConformingFloatEncodingStrategy = .throw

  /// The strategy to use for encoding keys.
  ///
  /// Defaults to `.useDefaultKeys`.
  open var keyEncodingStrategy: KeyEncodingStrategy = .useDefaultKeys

  /// Contextual user-provided information for use during encoding.
  open var userInfo: [CodingUserInfoKey: Any] = [:]

  /// The options set on the top-level encoder.
  internal var options: DictionaryEncoderOptions {
    DictionaryEncoderOptions(
      dateEncodingStrategy: dateEncodingStrategy,
      dataEncodingStrategy: dataEncodingStrategy,
      nonConformingFloatEncodingStrategy: nonConformingFloatEncodingStrategy,
      keyEncodingStrategy: keyEncodingStrategy,
      userInfo: userInfo
    )
  }

  // MARK: - Initializers

  /// Initializes `self` with default strategies.
  public init() {}
}

#if canImport(Combine)
  import Combine

  extension DictionaryEncoder: TopLevelEncoder {
    /// The type this encoder produces when encoding a value.
    public typealias Output = [String: Any]
  }
#endif
