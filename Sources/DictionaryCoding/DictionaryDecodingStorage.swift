//
//  DictionaryDecodingStorage.swift
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
