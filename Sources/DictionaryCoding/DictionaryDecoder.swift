//
//  DictionaryDecoder.swift
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
// Dictionary Decoder
// ===----------------------------------------------------------------------===//
/// `DictionaryDecoder` facilitates the decoding of Dictionary into semantic
/// `Decodable` types.
open class DictionaryDecoder {
  // MARK: - Subtypes

  /// The strategy to use for decoding `Date` values.
  public enum DateDecodingStrategy {
    /// Defer to `Date` for decoding. This is the default strategy.
    case deferredToDate

    /// Decode the `Date` as a UNIX timestamp from a Dictionary number.
    case secondsSince1970

    /// Decode the `Date` as UNIX millisecond timestamp from a Dictionary number.
    case millisecondsSince1970

    /// Decode the `Date` as an ISO-8601-formatted string (in RFC 3339 format).
    @available(OSX 10.12, iOS 10.0, watchOS 3.0, tvOS 10.0, *)
    case iso8601

    /// Decode the `Date` as a string parsed by the given formatter.
    case formatted(DateFormatter)

    /// Decode the `Date` as a custom value decoded by the given closure.
    case custom((_ decoder: Decoder) throws -> Date)
  }

  /// The strategy to use for decoding `Data` values.
  public enum DataDecodingStrategy {
    /// Defer to `Data` for decoding.
    case deferredToData

    /// Decode the `Data` from a Base64-encoded string. This is the default strategy.
    case base64

    /// Decode the `Data` as a custom value decoded by the given closure.
    case custom((_ decoder: Decoder) throws -> Data)
  }

  /// The strategy to use for non-Dictionary-conforming floating-point values
  /// (IEEE 754 infinity and NaN).
  public enum NonConformingFloatDecodingStrategy {
    /// Throw upon encountering non-conforming values. This is the default strategy.
    case `throw`

    /// Decode the values from the given representation strings.
    case convertFromString(
      positiveInfinity: String, negativeInfinity: String, nan: String
    )
  }

  /// The strategy to use when decoding missing keys.
  public enum MissingValueDecodingStrategy {
    /// Throw upon encountering missing values.
    case `throw`

    /// Attempt to use a default value when encountering missing values for
    /// standard types.
    case useStandardDefault

    /// Attempt to use a default value when encountering missing values.
    /// The default value is read from the associated dictionary, keyed by the
    /// name of the type.
    case useDefault(defaults: [String: Any])
  }

  /// The strategy to use for automatically changing the value of keys before decoding.
  public enum KeyDecodingStrategy {
    /// Use the keys specified by each type. This is the default strategy.
    case useDefaultKeys

    /// Convert from "snake_case_keys" to "camelCaseKeys" before attempting to
    /// match a key with the one specified by each type.
    ///
    /// Converting from snake case to camel case:
    /// 1. Capitalizes the word starting after each `_`
    /// 2. Removes all `_`
    /// 3. Preserves starting and ending `_`.
    /// For example, `one_two_three` becomes `oneTwoThree`.
    ///
    /// - Note: Using a key decoding strategy has a nominal performance cost.
    case convertFromSnakeCase

    /// Provide a custom conversion from the key in the encoded Dictionary to the
    /// keys specified by the decoded types.
    case custom((_ codingPath: [CodingKey]) -> CodingKey)
  }

  // MARK: - Instance Properties

  /// The strategy to use when values are missing.
  open var missingValueDecodingStrategy: MissingValueDecodingStrategy = .throw

  /// The strategy to use in decoding dates.
  ///
  /// Defaults to `.deferredToDate`.
  open var dateDecodingStrategy: DateDecodingStrategy = .deferredToDate

  /// The strategy to use in decoding binary data.
  ///
  /// Defaults to `.base64`.
  open var dataDecodingStrategy: DataDecodingStrategy = .base64

  /// The strategy to use in decoding non-conforming numbers.
  ///
  /// Defaults to `.throw`.
  open var nonConformingFloatDecodingStrategy: NonConformingFloatDecodingStrategy = .throw

  /// The strategy to use for decoding keys.
  ///
  /// Defaults to `.useDefaultKeys`.
  open var keyDecodingStrategy: KeyDecodingStrategy = .useDefaultKeys

  /// Contextual user-provided information for use during decoding.
  open var userInfo: [CodingUserInfoKey: Any] = [:]

  /// The options set on the top-level decoder.
  internal var options: DictionaryDecoderOptions {
    DictionaryDecoderOptions(
      missingValueDecodingStrategy: resolvedMissingValueStrategy,
      dateDecodingStrategy: dateDecodingStrategy,
      dataDecodingStrategy: dataDecodingStrategy,
      nonConformingFloatDecodingStrategy: nonConformingFloatDecodingStrategy,
      keyDecodingStrategy: keyDecodingStrategy,
      userInfo: userInfo
    )
  }

  // MARK: - Initializers

  /// Initializes `self` with default strategies.
  public init() {}
}

#if canImport(Combine)
  import Combine

  extension DictionaryDecoder: TopLevelDecoder {
    /// The type this decoder accepts when decoding a value.
    public typealias Input = [String: Any]
  }
#endif
