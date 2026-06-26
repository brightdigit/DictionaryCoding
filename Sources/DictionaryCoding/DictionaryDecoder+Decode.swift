//
//  DictionaryDecoder+Decode.swift
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

extension DictionaryDecoder {
  /// Decodes a top-level value of the given type from the given
  /// Dictionary representation.
  ///
  /// - Parameters:
  ///   - type: The type of the value to decode.
  ///   - dictionary: The data to decode from.
  /// - returns: A value of the requested type.
  /// - throws: `DecodingError.dataCorrupted` if values requested from the payload
  ///   are corrupted, or if the given data is not valid Dictionary.
  /// - throws: An error if any value throws an error during decoding.
  open func decode<T: Decodable>(
    _ type: T.Type,
    from dictionary: NSDictionary
  ) throws -> T {
    let decoder = DictionaryDecoderImpl(referencing: dictionary, options: self.options)
    guard let value = try decoder.unbox(dictionary, as: type) else {
      throw DecodingError.valueNotFound(
        type,
        DecodingError.Context(
          codingPath: [],
          debugDescription: "The given data did not contain a top-level value."
        )
      )
    }

    return value
  }

  /// Decodes a top-level value of the given type from the given
  /// Dictionary representation.
  ///
  /// - Parameters:
  ///   - type: The type of the value to decode.
  ///   - dictionary: The data to decode from.
  /// - returns: A value of the requested type.
  /// - throws: `DecodingError.dataCorrupted` if values requested from the payload
  ///   are corrupted, or if the given data is not valid Dictionary.
  /// - throws: An error if any value throws an error during decoding.
  open func decode<T: Decodable>(
    _ type: T.Type,
    from dictionary: [String: Any]
  ) throws -> T {
    let decoder = DictionaryDecoderImpl(referencing: dictionary, options: self.options)
    guard let value = try decoder.unbox(dictionary, as: type) else {
      throw DecodingError.valueNotFound(
        type,
        DecodingError.Context(
          codingPath: [],
          debugDescription: "The given data did not contain a top-level value."
        )
      )
    }

    return value
  }
}
