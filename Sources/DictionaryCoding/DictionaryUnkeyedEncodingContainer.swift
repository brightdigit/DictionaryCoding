//
//  DictionaryUnkeyedEncodingContainer.swift
//  AtLeast
//
//  Copyright (c) 2026 BrightDigit.
//  All rights reserved.
//

import Foundation

// MARK: - Unkeyed Encoding Container
internal struct DictionaryUnkeyedEncodingContainer: UnkeyedEncodingContainer {
  // MARK: - Instance Properties

  /// A reference to the encoder we're writing to.
  private let encoder: DictionaryEncoderImpl

  /// A reference to the container we're writing to.
  private let container: NSMutableArray

  /// The path of coding keys taken to get to this point in encoding.
  internal private(set) var codingPath: [CodingKey]

  // MARK: - Computed Properties

  /// The number of elements encoded into the container.
  internal var count: Int {
    self.container.count
  }

  // MARK: - Initializers

  /// Initializes `self` with the given references.
  internal init(
    referencing encoder: DictionaryEncoderImpl,
    codingPath: [CodingKey],
    wrapping container: NSMutableArray
  ) {
    self.encoder = encoder
    self.codingPath = codingPath
    self.container = container
  }

  // MARK: - Instance Methods

  internal mutating func encodeNil() throws {
    self.container.add(NSNull())
  }

  internal mutating func encode(_ value: Float) throws {
    // Since the float may be invalid and throw, the coding path needs to
    // contain this key.
    self.encoder.codingPath.append(DictionaryCodingKey(index: self.count))
    defer { self.encoder.codingPath.removeLast() }
    self.container.add(try self.encoder.box(value))
  }

  internal mutating func encode(_ value: Double) throws {
    // Since the double may be invalid and throw, the coding path needs to
    // contain this key.
    self.encoder.codingPath.append(DictionaryCodingKey(index: self.count))
    defer { self.encoder.codingPath.removeLast() }
    self.container.add(try self.encoder.box(value))
  }

  internal mutating func encode<T: Encodable>(_ value: T) throws {
    self.encoder.codingPath.append(DictionaryCodingKey(index: self.count))
    defer { self.encoder.codingPath.removeLast() }
    self.container.add(try self.encoder.box(value))
  }

  internal mutating func nestedContainer<NestedKey>(
    keyedBy keyType: NestedKey.Type
  ) -> KeyedEncodingContainer<NestedKey> {
    self.codingPath.append(DictionaryCodingKey(index: self.count))
    defer { self.codingPath.removeLast() }

    let dictionary = NSMutableDictionary()
    self.container.add(dictionary)

    let container = DictionaryCodingKeyedEncodingContainer<NestedKey>(
      referencing: self.encoder,
      codingPath: self.codingPath,
      wrapping: dictionary
    )
    return KeyedEncodingContainer(container)
  }

  internal mutating func nestedUnkeyedContainer() -> UnkeyedEncodingContainer {
    self.codingPath.append(DictionaryCodingKey(index: self.count))
    defer { self.codingPath.removeLast() }

    let array = NSMutableArray()
    self.container.add(array)
    return DictionaryUnkeyedEncodingContainer(
      referencing: self.encoder,
      codingPath: self.codingPath,
      wrapping: array
    )
  }

  internal mutating func superEncoder() -> Encoder {
    DictionaryReferencingEncoder(
      referencing: self.encoder,
      at: self.container.count,
      wrapping: self.container
    )
  }
}

// MARK: - Scalar encode methods
extension DictionaryUnkeyedEncodingContainer {
  internal mutating func encode(_ value: Bool) throws {
    self.container.add(self.encoder.box(value))
  }

  internal mutating func encode(_ value: Int) throws {
    self.container.add(self.encoder.box(value))
  }

  internal mutating func encode(_ value: Int8) throws {
    self.container.add(self.encoder.box(value))
  }

  internal mutating func encode(_ value: Int16) throws {
    self.container.add(self.encoder.box(value))
  }

  internal mutating func encode(_ value: Int32) throws {
    self.container.add(self.encoder.box(value))
  }

  internal mutating func encode(_ value: Int64) throws {
    self.container.add(self.encoder.box(value))
  }

  internal mutating func encode(_ value: UInt) throws {
    self.container.add(self.encoder.box(value))
  }

  internal mutating func encode(_ value: UInt8) throws {
    self.container.add(self.encoder.box(value))
  }

  internal mutating func encode(_ value: UInt16) throws {
    self.container.add(self.encoder.box(value))
  }

  internal mutating func encode(_ value: UInt32) throws {
    self.container.add(self.encoder.box(value))
  }

  internal mutating func encode(_ value: UInt64) throws {
    self.container.add(self.encoder.box(value))
  }

  internal mutating func encode(_ value: String) throws {
    self.container.add(self.encoder.box(value))
  }
}
