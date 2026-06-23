//
//  DictionaryDecoderImpl.swift
//  AtLeast
//
//  Copyright (c) 2026 BrightDigit.
//  All rights reserved.
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
