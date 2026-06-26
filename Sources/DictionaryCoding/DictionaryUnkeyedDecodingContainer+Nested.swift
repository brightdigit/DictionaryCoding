//
//  DictionaryUnkeyedDecodingContainer+Nested.swift
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

// MARK: - Nested container methods
extension DictionaryUnkeyedDecodingContainer {
  internal mutating func nestedContainer<NestedKey>(
    keyedBy type: NestedKey.Type
  ) throws -> KeyedDecodingContainer<NestedKey> {
    self.decoder.codingPath.append(DictionaryCodingKey(index: self.currentIndex))
    defer { self.decoder.codingPath.removeLast() }

    guard !self.isAtEnd else {
      throw DecodingError.valueNotFound(
        KeyedDecodingContainer<NestedKey>.self,
        DecodingError.Context(
          codingPath: self.codingPath,
          debugDescription:
            "Cannot get nested keyed container -- unkeyed container is at end."
        )
      )
    }

    let value = self.container[self.currentIndex]
    guard !(value is NSNull) else {
      throw DecodingError.valueNotFound(
        KeyedDecodingContainer<NestedKey>.self,
        DecodingError.Context(
          codingPath: self.codingPath,
          debugDescription:
            "Cannot get keyed decoding container -- found null value instead."
        )
      )
    }

    guard let dictionary = value as? [String: Any] else {
      throw DecodingError.typeMismatch(
        at: self.codingPath, expectation: [String: Any].self, reality: value
      )
    }

    self.currentIndex += 1
    let container = DictionaryCodingKeyedDecodingContainer<NestedKey>(
      referencing: self.decoder, wrapping: dictionary
    )
    return KeyedDecodingContainer(container)
  }

  internal mutating func nestedUnkeyedContainer() throws -> UnkeyedDecodingContainer {
    self.decoder.codingPath.append(DictionaryCodingKey(index: self.currentIndex))
    defer { self.decoder.codingPath.removeLast() }

    guard !self.isAtEnd else {
      throw DecodingError.valueNotFound(
        UnkeyedDecodingContainer.self,
        DecodingError.Context(
          codingPath: self.codingPath,
          debugDescription:
            "Cannot get nested keyed container -- unkeyed container is at end."
        )
      )
    }

    let value = self.container[self.currentIndex]
    guard !(value is NSNull) else {
      throw DecodingError.valueNotFound(
        UnkeyedDecodingContainer.self,
        DecodingError.Context(
          codingPath: self.codingPath,
          debugDescription:
            "Cannot get keyed decoding container -- found null value instead."
        )
      )
    }

    guard let array = value as? [Any] else {
      throw DecodingError.typeMismatch(
        at: self.codingPath, expectation: [Any].self, reality: value
      )
    }

    self.currentIndex += 1
    return DictionaryUnkeyedDecodingContainer(
      referencing: self.decoder, wrapping: array
    )
  }

  internal mutating func superDecoder() throws -> Decoder {
    self.decoder.codingPath.append(DictionaryCodingKey(index: self.currentIndex))
    defer { self.decoder.codingPath.removeLast() }

    guard !self.isAtEnd else {
      throw DecodingError.valueNotFound(
        Decoder.self,
        DecodingError.Context(
          codingPath: self.codingPath,
          debugDescription:
            "Cannot get superDecoder() -- unkeyed container is at end."
        )
      )
    }

    let value = self.container[self.currentIndex]
    self.currentIndex += 1
    return DictionaryDecoderImpl(
      referencing: value,
      at: self.decoder.codingPath,
      options: self.decoder.options
    )
  }
}
