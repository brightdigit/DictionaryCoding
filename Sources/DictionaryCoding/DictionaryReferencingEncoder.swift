//
//  DictionaryReferencingEncoder.swift
//  AtLeast
//
//  Copyright (c) 2026 BrightDigit.
//  All rights reserved.
//

import Foundation

// MARK: - DictionaryReferencingEncoder
/// DictionaryReferencingEncoder is a special subclass of DictionaryEncoderImpl
/// which has its own storage, but references the contents of a different encoder.
///
/// It's used in superEncoder(), which returns a new encoder for encoding a
/// superclass -- the lifetime of the encoder should not escape the scope it's
/// created in, but it doesn't necessarily know when it's done being used
/// (to write to the original container).
internal class DictionaryReferencingEncoder: DictionaryEncoderImpl {
  // MARK: - Subtypes

  /// The type of container we're referencing.
  private enum Reference {
    /// Referencing a specific index in an array container.
    case array(NSMutableArray, Int)

    /// Referencing a specific key in a dictionary container.
    case dictionary(NSMutableDictionary, String)
  }

  // MARK: - Instance Properties

  /// The encoder we're referencing.
  internal let referencedEncoder: DictionaryEncoderImpl

  /// The container reference itself.
  private let reference: Reference

  // MARK: - Computed Properties

  override internal var canEncodeNewValue: Bool {
    // With a regular encoder, the storage and coding path grow together.
    // A referencing encoder, however, inherits its parents coding path,
    // as well as the key it was created for.
    // We have to take this into account.
    self.storage.count == self.codingPath.count
      - self.referencedEncoder.codingPath.count - 1
  }

  // MARK: - Initializers

  /// Initializes `self` by referencing the given array container in the given encoder.
  internal init(
    referencing encoder: DictionaryEncoderImpl,
    at index: Int,
    wrapping array: NSMutableArray
  ) {
    self.referencedEncoder = encoder
    self.reference = .array(array, index)
    super.init(options: encoder.options, codingPath: encoder.codingPath)

    self.codingPath.append(DictionaryCodingKey(index: index))
  }

  /// Initializes `self` by referencing the given dictionary container
  /// in the given encoder.
  internal init(
    referencing encoder: DictionaryEncoderImpl,
    key: CodingKey,
    convertedKey: CodingKey,
    wrapping dictionary: NSMutableDictionary
  ) {
    self.referencedEncoder = encoder
    self.reference = .dictionary(dictionary, convertedKey.stringValue)
    super.init(options: encoder.options, codingPath: encoder.codingPath)

    self.codingPath.append(key)
  }

  // MARK: - Deinitialization

  // Finalizes `self` by writing the contents of our storage to the referenced
  // encoder's storage.
  deinit {
    let value: Any
    switch self.storage.count {
    case 0:
      value = NSDictionary()
    case 1:
      value = self.storage.popContainer()
    default:
      fatalError(
        "Referencing encoder deallocated with multiple containers on stack."
      )
    }

    switch self.reference {
    case let .array(array, index):
      array.insert(value, at: index)

    case let .dictionary(dictionary, key):
      dictionary[NSString(string: key)] = value
    }
  }
}
