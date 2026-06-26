//
//  DictionaryDecoderImpl.swift
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

// MARK: - DictionaryDecoderImpl
internal class DictionaryDecoderImpl: Decoder {
  // MARK: - Instance Properties

  /// The decoder's storage.
  internal var storage: DictionaryDecodingStorage

  /// Options set on the top-level decoder.
  internal let options: DictionaryDecoderOptions

  /// The path to the current point in encoding.
  internal var codingPath: [CodingKey]

  /// Contextual user-provided information for use during encoding.
  internal var userInfo: [CodingUserInfoKey: Any] {
    self.options.userInfo
  }

  // MARK: - Initializers

  /// Initializes `self` with the given top-level container and options.
  internal init(
    referencing container: Any,
    at codingPath: [CodingKey] = [],
    options: DictionaryDecoderOptions
  ) {
    self.storage = DictionaryDecodingStorage()
    self.storage.push(container: container)
    self.codingPath = codingPath
    self.options = options
  }

  // MARK: - Instance Methods

  internal func container<Key>(
    keyedBy type: Key.Type
  ) throws -> KeyedDecodingContainer<Key> {
    guard !(self.storage.topContainer is NSNull) else {
      throw DecodingError.valueNotFound(
        KeyedDecodingContainer<Key>.self,
        DecodingError.Context(
          codingPath: self.codingPath,
          debugDescription:
            "Cannot get keyed decoding container -- found null value instead."
        )
      )
    }

    guard let topContainer = self.storage.topContainer as? [String: Any] else {
      throw DecodingError.typeMismatch(
        at: self.codingPath,
        expectation: [String: Any].self,
        reality: self.storage.topContainer
      )
    }

    let container = DictionaryCodingKeyedDecodingContainer<Key>(
      referencing: self,
      wrapping: topContainer
    )
    return KeyedDecodingContainer(container)
  }

  internal func unkeyedContainer() throws -> UnkeyedDecodingContainer {
    guard !(self.storage.topContainer is NSNull) else {
      throw DecodingError.valueNotFound(
        UnkeyedDecodingContainer.self,
        DecodingError.Context(
          codingPath: self.codingPath,
          debugDescription:
            "Cannot get unkeyed decoding container -- found null value instead."
        )
      )
    }

    guard let topContainer = self.storage.topContainer as? [Any] else {
      throw DecodingError.typeMismatch(
        at: self.codingPath,
        expectation: [Any].self,
        reality: self.storage.topContainer
      )
    }

    return DictionaryUnkeyedDecodingContainer(
      referencing: self,
      wrapping: topContainer
    )
  }

  internal func singleValueContainer() throws -> SingleValueDecodingContainer {
    self
  }
}
