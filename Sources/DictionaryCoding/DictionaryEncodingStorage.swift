//
//  DictionaryEncodingStorage.swift
//  AtLeast
//
//  Copyright (c) 2026 BrightDigit.
//  All rights reserved.
//

import Foundation

// MARK: - Encoding Storage and Containers
internal struct DictionaryEncodingStorage {
  // MARK: - Instance Properties

  /// The container stack.
  ///
  /// Elements may be any one of the Dictionary types
  /// (NSNull, NSNumber, NSString, NSArray, NSDictionary).
  internal private(set) var containers: [NSObject] = []

  // MARK: - Computed Properties

  internal var count: Int {
    self.containers.count
  }

  // MARK: - Initializers

  /// Initializes `self` with no containers.
  internal init() {}

  // MARK: - Instance Methods

  internal mutating func pushKeyedContainer() -> NSMutableDictionary {
    let dictionary = NSMutableDictionary()
    self.containers.append(dictionary)
    return dictionary
  }

  internal mutating func pushUnkeyedContainer() -> NSMutableArray {
    let array = NSMutableArray()
    self.containers.append(array)
    return array
  }

  internal mutating func push(container: NSObject) {
    self.containers.append(container)
  }

  internal mutating func popContainer() -> NSObject {
    precondition(!self.containers.isEmpty, "Empty container stack.")
    return self.containers.removeLast()
  }
}
