//
//  DictionaryDecoderImpl+SingleValue.swift
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

// MARK: - SingleValueDecodingContainer
extension DictionaryDecoderImpl: SingleValueDecodingContainer {
  internal func expectNonNull<T>(_ type: T.Type) throws {
    guard !self.decodeNil() else {
      throw DecodingError.valueNotFound(
        type,
        DecodingError.Context(
          codingPath: self.codingPath,
          debugDescription: "Expected \(type) but found null value instead."
        )
      )
    }
  }

  internal func nullValueError<T>(_ type: T.Type) -> DecodingError {
    DecodingError.valueNotFound(
      type,
      DecodingError.Context(
        codingPath: self.codingPath,
        debugDescription: "Expected \(type) but found null value instead."
      )
    )
  }

  /// Returns whether the value stored in the container is null.
  public func decodeNil() -> Bool {
    self.storage.topContainer is NSNull
  }

  /// Decodes a single value of the given type.
  public func decode(_ type: Bool.Type) throws -> Bool {
    try expectNonNull(Bool.self)
    guard let value = try self.unbox(self.storage.topContainer, as: Bool.self) else {
      throw nullValueError(type)
    }
    return value
  }

  /// Decodes a single value of the given type.
  public func decode(_ type: Int.Type) throws -> Int {
    try expectNonNull(Int.self)
    guard let value = try self.unbox(self.storage.topContainer, as: Int.self) else {
      throw nullValueError(type)
    }
    return value
  }

  /// Decodes a single value of the given type.
  public func decode(_ type: Int8.Type) throws -> Int8 {
    try expectNonNull(Int8.self)
    guard let value = try self.unbox(self.storage.topContainer, as: Int8.self) else {
      throw nullValueError(type)
    }
    return value
  }

  /// Decodes a single value of the given type.
  public func decode(_ type: Int16.Type) throws -> Int16 {
    try expectNonNull(Int16.self)
    guard let value = try self.unbox(self.storage.topContainer, as: Int16.self) else {
      throw nullValueError(type)
    }
    return value
  }

  /// Decodes a single value of the given type.
  public func decode(_ type: Int32.Type) throws -> Int32 {
    try expectNonNull(Int32.self)
    guard let value = try self.unbox(self.storage.topContainer, as: Int32.self) else {
      throw nullValueError(type)
    }
    return value
  }

  /// Decodes a single value of the given type.
  public func decode(_ type: Int64.Type) throws -> Int64 {
    try expectNonNull(Int64.self)
    guard let value = try self.unbox(self.storage.topContainer, as: Int64.self) else {
      throw nullValueError(type)
    }
    return value
  }

  /// Decodes a single value of the given type.
  public func decode(_ type: UInt.Type) throws -> UInt {
    try expectNonNull(UInt.self)
    guard let value = try self.unbox(self.storage.topContainer, as: UInt.self) else {
      throw nullValueError(type)
    }
    return value
  }

  /// Decodes a single value of the given type.
  public func decode(_ type: UInt8.Type) throws -> UInt8 {
    try expectNonNull(UInt8.self)
    guard let value = try self.unbox(self.storage.topContainer, as: UInt8.self) else {
      throw nullValueError(type)
    }
    return value
  }

  /// Decodes a single value of the given type.
  public func decode(_ type: UInt16.Type) throws -> UInt16 {
    try expectNonNull(UInt16.self)
    guard let value = try self.unbox(self.storage.topContainer, as: UInt16.self) else {
      throw nullValueError(type)
    }
    return value
  }

  /// Decodes a single value of the given type.
  public func decode(_ type: UInt32.Type) throws -> UInt32 {
    try expectNonNull(UInt32.self)
    guard let value = try self.unbox(self.storage.topContainer, as: UInt32.self) else {
      throw nullValueError(type)
    }
    return value
  }

  /// Decodes a single value of the given type.
  public func decode(_ type: UInt64.Type) throws -> UInt64 {
    try expectNonNull(UInt64.self)
    guard let value = try self.unbox(self.storage.topContainer, as: UInt64.self) else {
      throw nullValueError(type)
    }
    return value
  }

  /// Decodes a single value of the given type.
  public func decode(_ type: Float.Type) throws -> Float {
    try expectNonNull(Float.self)
    guard let value = try self.unbox(self.storage.topContainer, as: Float.self) else {
      throw nullValueError(type)
    }
    return value
  }

  /// Decodes a single value of the given type.
  public func decode(_ type: Double.Type) throws -> Double {
    try expectNonNull(Double.self)
    guard let value = try self.unbox(self.storage.topContainer, as: Double.self) else {
      throw nullValueError(type)
    }
    return value
  }

  /// Decodes a single value of the given type.
  public func decode(_ type: String.Type) throws -> String {
    try expectNonNull(String.self)
    guard let value = try self.unbox(self.storage.topContainer, as: String.self) else {
      throw nullValueError(type)
    }
    return value
  }

  /// Decodes a single value of the given type.
  public func decode<T: Decodable>(_ type: T.Type) throws -> T {
    try expectNonNull(type)
    guard let value = try self.unbox(self.storage.topContainer, as: type) else {
      throw nullValueError(type)
    }
    return value
  }
}
