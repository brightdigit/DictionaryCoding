//
//  DictionaryEncoderImpl.swift
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

// MARK: - DictionaryEncoderImpl
internal class DictionaryEncoderImpl: Encoder {
  // MARK: - Instance Properties

  /// The encoder's storage.
  internal var storage: DictionaryEncodingStorage

  /// Options set on the top-level encoder.
  internal let options: DictionaryEncoderOptions

  /// The path to the current point in encoding.
  internal var codingPath: [CodingKey]

  /// Contextual user-provided information for use during encoding.
  internal var userInfo: [CodingUserInfoKey: Any] {
    self.options.userInfo
  }

  /// Returns whether a new element can be encoded at this coding path.
  ///
  /// `true` if an element has not yet been encoded at this coding path;
  /// `false` otherwise.
  internal var canEncodeNewValue: Bool {
    // Every time a new value gets encoded, the key it's encoded for is pushed
    // onto the coding path (even if it's a nil key from an unkeyed container).
    // At the same time, every time a container is requested, a new value gets
    // pushed onto the storage stack.
    // If there are more values on the storage stack than on the coding path,
    // it means the value is requesting more than one container, which violates
    // the precondition.
    //
    // This means that anytime something that can request a new container goes
    // onto the stack, we MUST push a key onto the coding path.
    // Things which will not request containers do not need to have the coding
    // path extended for them (but it doesn't matter if it is, because they
    // will not reach here).
    self.storage.count == self.codingPath.count
  }

  // MARK: - Initializers

  /// Initializes `self` with the given top-level encoder options.
  internal init(options: DictionaryEncoderOptions, codingPath: [CodingKey] = []) {
    self.options = options
    self.storage = DictionaryEncodingStorage()
    self.codingPath = codingPath
  }

  // MARK: - Instance Methods

  internal func container<Key>(keyedBy: Key.Type) -> KeyedEncodingContainer<Key> {
    // If an existing keyed container was already requested, return that one.
    let topContainer: NSMutableDictionary
    if self.canEncodeNewValue {
      // We haven't yet pushed a container at this level; do so here.
      topContainer = self.storage.pushKeyedContainer()
    } else {
      guard let container = self.storage.containers.last as? NSMutableDictionary
      else {
        preconditionFailure(
          "Attempt to push new keyed encoding container when already previously"
            + " encoded at this path."
        )
      }
      topContainer = container
    }

    let container = DictionaryCodingKeyedEncodingContainer<Key>(
      referencing: self,
      codingPath: self.codingPath,
      wrapping: topContainer
    )
    return KeyedEncodingContainer(container)
  }

  internal func unkeyedContainer() -> UnkeyedEncodingContainer {
    // If an existing unkeyed container was already requested, return that one.
    let topContainer: NSMutableArray
    if self.canEncodeNewValue {
      // We haven't yet pushed a container at this level; do so here.
      topContainer = self.storage.pushUnkeyedContainer()
    } else {
      guard let container = self.storage.containers.last as? NSMutableArray else {
        preconditionFailure(
          "Attempt to push new unkeyed encoding container when already previously"
            + " encoded at this path."
        )
      }
      topContainer = container
    }

    return DictionaryUnkeyedEncodingContainer(
      referencing: self,
      codingPath: self.codingPath,
      wrapping: topContainer
    )
  }

  internal func singleValueContainer() -> SingleValueEncodingContainer {
    self
  }
}
