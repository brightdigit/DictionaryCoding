//
//  DictionaryCodingKeyedEncodingContainer.swift
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

// MARK: - Keyed Encoding Container
internal struct DictionaryCodingKeyedEncodingContainer<K: CodingKey>:
  KeyedEncodingContainerProtocol
{
  internal typealias Key = K

  // MARK: - Instance Properties

  /// A reference to the encoder we're writing to.
  private let encoder: DictionaryEncoderImpl

  /// A reference to the container we're writing to.
  private let container: NSMutableDictionary

  /// The path of coding keys taken to get to this point in encoding.
  internal private(set) var codingPath: [CodingKey]

  // MARK: - Initializers

  /// Initializes `self` with the given references.
  internal init(
    referencing encoder: DictionaryEncoderImpl,
    codingPath: [CodingKey],
    wrapping container: NSMutableDictionary
  ) {
    self.encoder = encoder
    self.codingPath = codingPath
    self.container = container
  }

  // MARK: - Instance Methods

  private func converted(_ key: CodingKey) -> CodingKey {
    switch encoder.options.keyEncodingStrategy {
    case .useDefaultKeys:
      return key
    case .convertToSnakeCase:
      let newKeyString =
        DictionaryEncoder.KeyEncodingStrategy.convertToSnakeCase(key.stringValue)
      return DictionaryCodingKey(stringValue: newKeyString, intValue: key.intValue)
    case .custom(let converter):
      return converter(codingPath + [key])
    }
  }

  internal mutating func encodeNil(forKey key: Key) throws {
    self.container[converted(key).stringValue] = NSNull()
  }

  internal mutating func encode(_ value: Bool, forKey key: Key) throws {
    self.container[converted(key).stringValue] = self.encoder.box(value)
  }

  internal mutating func encode(_ value: Int, forKey key: Key) throws {
    self.container[converted(key).stringValue] = self.encoder.box(value)
  }

  internal mutating func encode(_ value: Int8, forKey key: Key) throws {
    self.container[converted(key).stringValue] = self.encoder.box(value)
  }

  internal mutating func encode(_ value: Int16, forKey key: Key) throws {
    self.container[converted(key).stringValue] = self.encoder.box(value)
  }

  internal mutating func encode(_ value: Int32, forKey key: Key) throws {
    self.container[converted(key).stringValue] = self.encoder.box(value)
  }

  internal mutating func encode(_ value: Int64, forKey key: Key) throws {
    self.container[converted(key).stringValue] = self.encoder.box(value)
  }

  internal mutating func encode(_ value: UInt, forKey key: Key) throws {
    self.container[converted(key).stringValue] = self.encoder.box(value)
  }

  internal mutating func encode(_ value: UInt8, forKey key: Key) throws {
    self.container[converted(key).stringValue] = self.encoder.box(value)
  }

  internal mutating func encode(_ value: UInt16, forKey key: Key) throws {
    self.container[converted(key).stringValue] = self.encoder.box(value)
  }

  internal mutating func encode(_ value: UInt32, forKey key: Key) throws {
    self.container[converted(key).stringValue] = self.encoder.box(value)
  }

  internal mutating func encode(_ value: UInt64, forKey key: Key) throws {
    self.container[converted(key).stringValue] = self.encoder.box(value)
  }

  internal mutating func encode(_ value: String, forKey key: Key) throws {
    self.container[converted(key).stringValue] = self.encoder.box(value)
  }

  internal mutating func encode(_ value: Float, forKey key: Key) throws {
    // Since the float may be invalid and throw, the coding path needs to
    // contain this key.
    self.encoder.codingPath.append(key)
    defer { self.encoder.codingPath.removeLast() }
    self.container[converted(key).stringValue] = try self.encoder.box(value)
  }

  internal mutating func encode(_ value: Double, forKey key: Key) throws {
    // Since the double may be invalid and throw, the coding path needs to
    // contain this key.
    self.encoder.codingPath.append(key)
    defer { self.encoder.codingPath.removeLast() }
    self.container[converted(key).stringValue] = try self.encoder.box(value)
  }

  internal mutating func encode<T: Encodable>(_ value: T, forKey key: Key) throws {
    self.encoder.codingPath.append(key)
    defer { self.encoder.codingPath.removeLast() }
    self.container[converted(key).stringValue] = try self.encoder.box(value)
  }

  internal mutating func nestedContainer<NestedKey>(
    keyedBy keyType: NestedKey.Type,
    forKey key: Key
  ) -> KeyedEncodingContainer<NestedKey> {
    let dictionary = NSMutableDictionary()
    self.container[converted(key).stringValue] = dictionary

    self.codingPath.append(key)
    defer { self.codingPath.removeLast() }

    let container = DictionaryCodingKeyedEncodingContainer<NestedKey>(
      referencing: self.encoder,
      codingPath: self.codingPath,
      wrapping: dictionary
    )
    return KeyedEncodingContainer(container)
  }

  internal mutating func nestedUnkeyedContainer(
    forKey key: Key
  ) -> UnkeyedEncodingContainer {
    let array = NSMutableArray()
    self.container[converted(key).stringValue] = array

    self.codingPath.append(key)
    defer { self.codingPath.removeLast() }
    return DictionaryUnkeyedEncodingContainer(
      referencing: self.encoder,
      codingPath: self.codingPath,
      wrapping: array
    )
  }

  internal mutating func superEncoder() -> Encoder {
    DictionaryReferencingEncoder(
      referencing: self.encoder,
      key: DictionaryCodingKey.super,
      convertedKey: converted(DictionaryCodingKey.super),
      wrapping: self.container
    )
  }

  internal mutating func superEncoder(forKey key: Key) -> Encoder {
    DictionaryReferencingEncoder(
      referencing: self.encoder,
      key: key,
      convertedKey: converted(key),
      wrapping: self.container
    )
  }
}
