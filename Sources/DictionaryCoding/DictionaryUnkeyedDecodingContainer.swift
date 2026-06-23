//
//  DictionaryUnkeyedDecodingContainer.swift
//  AtLeast
//
//  Copyright (c) 2026 BrightDigit.
//  All rights reserved.
//

import Foundation

// MARK: - Unkeyed Decoding Container
internal struct DictionaryUnkeyedDecodingContainer: UnkeyedDecodingContainer {
  // MARK: - Instance Properties

  /// A reference to the decoder we're reading from.
  internal let decoder: DictionaryDecoderImpl

  /// A reference to the container we're reading from.
  internal let container: [Any]

  /// The path of coding keys taken to get to this point in decoding.
  internal private(set) var codingPath: [CodingKey]

  /// The index of the element we're about to decode.
  internal var currentIndex: Int

  // MARK: - Computed Properties

  internal var count: Int? {
    self.container.count
  }

  internal var isAtEnd: Bool {
    guard let count = self.count else {
      return true
    }
    return self.currentIndex >= count
  }

  // MARK: - Initializers

  /// Initializes `self` by referencing the given decoder and container.
  internal init(referencing decoder: DictionaryDecoderImpl, wrapping container: [Any]) {
    self.decoder = decoder
    self.container = container
    self.codingPath = decoder.codingPath
    self.currentIndex = 0
  }

  // MARK: - Instance Methods

  internal func atEndError<T>(_ type: T.Type) -> DecodingError {
    DecodingError.valueNotFound(
      type,
      DecodingError.Context(
        codingPath: self.decoder.codingPath
          + [DictionaryCodingKey(index: self.currentIndex)],
        debugDescription: "Unkeyed container is at end."
      )
    )
  }

  internal func nullFoundError<T>(_ type: T.Type) -> DecodingError {
    DecodingError.valueNotFound(
      type,
      DecodingError.Context(
        codingPath: self.decoder.codingPath
          + [DictionaryCodingKey(index: self.currentIndex)],
        debugDescription: "Expected \(type) but found null instead."
      )
    )
  }

  internal mutating func decodeNil() throws -> Bool {
    guard !self.isAtEnd else {
      throw DecodingError.valueNotFound(
        Any?.self,
        DecodingError.Context(
          codingPath: self.decoder.codingPath
            + [DictionaryCodingKey(index: self.currentIndex)],
          debugDescription: "Unkeyed container is at end."
        )
      )
    }

    if self.container[self.currentIndex] is NSNull {
      self.currentIndex += 1
      return true
    } else {
      return false
    }
  }

  internal mutating func decode<T: Decodable>(_ type: T.Type) throws -> T {
    guard !self.isAtEnd else {
      throw atEndError(type)
    }

    self.decoder.codingPath.append(DictionaryCodingKey(index: self.currentIndex))
    defer { self.decoder.codingPath.removeLast() }

    guard
      let decoded =
        try self.decoder.unbox(self.container[self.currentIndex], as: type)
    else {
      throw nullFoundError(type)
    }

    self.currentIndex += 1
    return decoded
  }
}
