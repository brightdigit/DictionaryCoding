//
//  DictionaryEncoderImpl+SingleValue.swift
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

// MARK: - SingleValueEncodingContainer
extension DictionaryEncoderImpl: SingleValueEncodingContainer {
  internal func assertCanEncodeNewValue() {
    precondition(
      self.canEncodeNewValue,
      "Attempt to encode value through single value container when previously"
        + " value already encoded."
    )
  }

  /// Encodes a null value.
  public func encodeNil() throws {
    assertCanEncodeNewValue()
    self.storage.push(container: NSNull())
  }

  /// Encodes the given value into the single-value container.
  public func encode(_ value: Bool) throws {
    assertCanEncodeNewValue()
    self.storage.push(container: self.box(value))
  }

  /// Encodes the given value into the single-value container.
  public func encode(_ value: Int) throws {
    assertCanEncodeNewValue()
    self.storage.push(container: self.box(value))
  }

  /// Encodes the given value into the single-value container.
  public func encode(_ value: Int8) throws {
    assertCanEncodeNewValue()
    self.storage.push(container: self.box(value))
  }

  /// Encodes the given value into the single-value container.
  public func encode(_ value: Int16) throws {
    assertCanEncodeNewValue()
    self.storage.push(container: self.box(value))
  }

  /// Encodes the given value into the single-value container.
  public func encode(_ value: Int32) throws {
    assertCanEncodeNewValue()
    self.storage.push(container: self.box(value))
  }

  /// Encodes the given value into the single-value container.
  public func encode(_ value: Int64) throws {
    assertCanEncodeNewValue()
    self.storage.push(container: self.box(value))
  }

  /// Encodes the given value into the single-value container.
  public func encode(_ value: UInt) throws {
    assertCanEncodeNewValue()
    self.storage.push(container: self.box(value))
  }

  /// Encodes the given value into the single-value container.
  public func encode(_ value: UInt8) throws {
    assertCanEncodeNewValue()
    self.storage.push(container: self.box(value))
  }

  /// Encodes the given value into the single-value container.
  public func encode(_ value: UInt16) throws {
    assertCanEncodeNewValue()
    self.storage.push(container: self.box(value))
  }

  /// Encodes the given value into the single-value container.
  public func encode(_ value: UInt32) throws {
    assertCanEncodeNewValue()
    self.storage.push(container: self.box(value))
  }

  /// Encodes the given value into the single-value container.
  public func encode(_ value: UInt64) throws {
    assertCanEncodeNewValue()
    self.storage.push(container: self.box(value))
  }

  /// Encodes the given value into the single-value container.
  public func encode(_ value: String) throws {
    assertCanEncodeNewValue()
    self.storage.push(container: self.box(value))
  }

  /// Encodes the given value into the single-value container.
  public func encode(_ value: Float) throws {
    assertCanEncodeNewValue()
    try self.storage.push(container: self.box(value))
  }

  /// Encodes the given value into the single-value container.
  public func encode(_ value: Double) throws {
    assertCanEncodeNewValue()
    try self.storage.push(container: self.box(value))
  }

  /// Encodes the given value into the single-value container.
  public func encode<T: Encodable>(_ value: T) throws {
    assertCanEncodeNewValue()
    try self.storage.push(container: self.box(value))
  }
}
