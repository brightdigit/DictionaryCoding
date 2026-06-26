//
//  DictionaryEncodingStorage.swift
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
