//
//  DictionaryDecodingStorage.swift
//  AtLeast
//
//  Copyright (c) 2026 BrightDigit.
//  All rights reserved.
//

import Foundation

// MARK: - Decoding Storage
internal struct DictionaryDecodingStorage {
  // MARK: - Instance Properties

  /// The container stack.
  ///
  /// Elements may be any one of the Dictionary types
  /// (NSNull, NSNumber, String, Array, [String : Any]).
  internal private(set) var containers: [Any] = []

  // MARK: - Computed Properties

  internal var count: Int {
    self.containers.count
  }

  internal var topContainer: Any {
    precondition(!self.containers.isEmpty, "Empty container stack.")
    guard let last = self.containers.last else {
      fatalError("Empty container stack.")
    }
    return last
  }

  // MARK: - Initializers

  /// Initializes `self` with no containers.
  internal init() {}

  // MARK: - Instance Methods

  internal mutating func push(container: Any) {
    self.containers.append(container)
  }

  internal mutating func popContainer() {
    precondition(!self.containers.isEmpty, "Empty container stack.")
    self.containers.removeLast()
  }
}
