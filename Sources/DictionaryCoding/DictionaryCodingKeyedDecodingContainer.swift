//
//  DictionaryCodingKeyedDecodingContainer.swift
//  AtLeast
//
//  Copyright (c) 2026 BrightDigit.
//  All rights reserved.
//

import Foundation

// MARK: - Keyed Decoding Container
internal struct DictionaryCodingKeyedDecodingContainer<K: CodingKey>:
  KeyedDecodingContainerProtocol
{
  internal typealias Key = K

  // MARK: - Instance Properties

  /// A reference to the decoder we're reading from.
  internal let decoder: DictionaryDecoderImpl

  /// A reference to the container we're reading from.
  internal let container: [String: Any]

  /// The path of coding keys taken to get to this point in decoding.
  internal private(set) var codingPath: [CodingKey]

  // MARK: - Computed Properties

  internal var allKeys: [Key] {
    self.container.keys.compactMap { Key(stringValue: $0) }
  }

  // MARK: - Initializers

  /// Initializes `self` by referencing the given decoder and container.
  internal init(
    referencing decoder: DictionaryDecoderImpl,
    wrapping container: [String: Any]
  ) {
    self.decoder = decoder
    switch decoder.options.keyDecodingStrategy {
    case .useDefaultKeys:
      self.container = container
    case .convertFromSnakeCase:
      // Convert the snake case keys in the container to camel case.
      // If we hit a duplicate key after conversion, then we'll use the first one
      // we saw. Effectively an undefined behavior with Dictionary dictionaries.
      self.container = Dictionary(
        container.map { key, value in
          (DictionaryDecoder.KeyDecodingStrategy.convertFromSnakeCase(key), value)
        },
        uniquingKeysWith: { first, _ in first }
      )
    case .custom(let converter):
      self.container = Dictionary(
        container.map { key, value in
          (
            converter(
              decoder.codingPath
                + [DictionaryCodingKey(stringValue: key, intValue: nil)]
            ).stringValue,
            value
          )
        },
        uniquingKeysWith: { first, _ in first }
      )
    }
    self.codingPath = decoder.codingPath
  }

  // MARK: - Instance Methods

  internal func contains(_ key: Key) -> Bool {
    self.container[key.stringValue] != nil
  }

  internal func notFoundError(key: Key) -> DecodingError {
    DecodingError.keyNotFound(
      key,
      DecodingError.Context(
        codingPath: self.decoder.codingPath,
        debugDescription:
          "No value associated with key \(errorDescription(of: key))."
      )
    )
  }

  internal func nullFoundError<T>(type: T.Type) -> DecodingError {
    DecodingError.valueNotFound(
      type,
      DecodingError.Context(
        codingPath: self.decoder.codingPath,
        debugDescription: "Expected \(type) value but found null instead."
      )
    )
  }

  internal func errorDescription(of key: CodingKey) -> String {
    switch decoder.options.keyDecodingStrategy {
    case .convertFromSnakeCase:
      let original = key.stringValue
      let converted =
        DictionaryEncoder.KeyEncodingStrategy.convertToSnakeCase(original)
      if converted == original {
        return "\(key) (\"\(original)\")"
      } else {
        return "\(key) (\"\(original)\"), converted to \(converted)"
      }
    default:
      return "\(key) (\"\(key.stringValue)\")"
    }
  }

  internal func decodeNil(forKey key: Key) throws -> Bool {
    guard let entry = self.container[key.stringValue] else {
      throw notFoundError(key: key)
    }

    return entry is NSNull
  }

  internal func decode<T: Decodable>(_ type: T.Type, forKey key: Key) throws -> T {
    guard let entry = self.container[key.stringValue] else {
      switch decoder.options.missingValueDecodingStrategy {
      case .useDefault(let defaults):
        let defaultKey = "\(type)"
        if let def = defaults[defaultKey] as? T {
          return def
        }
      default:
        break
      }

      throw notFoundError(key: key)
    }

    self.decoder.codingPath.append(key)
    defer { self.decoder.codingPath.removeLast() }

    guard let value = try self.decoder.unbox(entry, as: type) else {
      throw nullFoundError(type: type)
    }

    return value
  }
}

// MARK: - Nested containers and superDecoder
extension DictionaryCodingKeyedDecodingContainer {
  internal func nestedContainer<NestedKey>(
    keyedBy type: NestedKey.Type,
    forKey key: Key
  ) throws -> KeyedDecodingContainer<NestedKey> {
    self.decoder.codingPath.append(key)
    defer { self.decoder.codingPath.removeLast() }

    guard let value = self.container[key.stringValue] else {
      throw DecodingError.keyNotFound(
        key,
        DecodingError.Context(
          codingPath: self.codingPath,
          debugDescription:
            "Cannot get \(KeyedDecodingContainer<NestedKey>.self)"
            + " -- no value found for key \(errorDescription(of: key))"
        )
      )
    }

    guard let dictionary = value as? [String: Any] else {
      throw DecodingError.typeMismatch(
        at: self.codingPath, expectation: [String: Any].self, reality: value
      )
    }

    let container = DictionaryCodingKeyedDecodingContainer<NestedKey>(
      referencing: self.decoder, wrapping: dictionary
    )
    return KeyedDecodingContainer(container)
  }

  internal func nestedUnkeyedContainer(
    forKey key: Key
  ) throws -> UnkeyedDecodingContainer {
    self.decoder.codingPath.append(key)
    defer { self.decoder.codingPath.removeLast() }

    guard let value = self.container[key.stringValue] else {
      throw DecodingError.keyNotFound(
        key,
        DecodingError.Context(
          codingPath: self.codingPath,
          debugDescription:
            "Cannot get UnkeyedDecodingContainer"
            + " -- no value found for key \(errorDescription(of: key))"
        )
      )
    }

    guard let array = value as? [Any] else {
      throw DecodingError.typeMismatch(
        at: self.codingPath, expectation: [Any].self, reality: value
      )
    }

    return DictionaryUnkeyedDecodingContainer(
      referencing: self.decoder, wrapping: array
    )
  }

  internal func superDecoder() throws -> Decoder {
    try makeSuperDecoder(forKey: DictionaryCodingKey.super)
  }

  internal func superDecoder(forKey key: Key) throws -> Decoder {
    try makeSuperDecoder(forKey: key)
  }

  private func makeSuperDecoder(forKey key: CodingKey) throws -> Decoder {
    self.decoder.codingPath.append(key)
    defer { self.decoder.codingPath.removeLast() }

    let value: Any = self.container[key.stringValue] ?? NSNull()
    return DictionaryDecoderImpl(
      referencing: value,
      at: self.decoder.codingPath,
      options: self.decoder.options
    )
  }
}
