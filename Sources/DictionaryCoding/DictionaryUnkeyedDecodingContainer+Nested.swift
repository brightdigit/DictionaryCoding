//
//  DictionaryUnkeyedDecodingContainer+Nested.swift
//  AtLeast
//
//  Copyright (c) 2026 BrightDigit.
//  All rights reserved.
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
