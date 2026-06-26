//
//  DictionaryEncoderImpl+BoxEncodable.swift
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

// MARK: - Encodable Value Representations
extension DictionaryEncoderImpl {
  internal func box<T: Encodable>(_ value: T) throws -> NSObject {
    try self.boxEncodable(value) ?? NSDictionary()
  }

  // This method is called "boxEncodable" instead of "box" to disambiguate it from the
  // overloads. Because the return type here is different from all of the "box"
  // overloads (and is more general), any "box" calls in here would call back
  // into "box" recursively instead of calling the appropriate overload, which
  // is not what we want.
  internal func boxEncodable<T: Encodable>(_ value: T) throws -> NSObject? {
    if let result = try boxSpecialType(value) {
      return result
    }

    return try boxGenericEncodable(value)
  }

  private func boxSpecialType<T: Encodable>(_ value: T) throws -> NSObject? {
    if T.self == Date.self || T.self == NSDate.self {
      return try boxAsDate(value)
    } else if T.self == Data.self || T.self == NSData.self {
      return try boxAsData(value)
    } else if T.self == URL.self || T.self == NSURL.self {
      return boxAsURL(value)
    } else if T.self == Decimal.self || T.self == NSDecimalNumber.self {
      return boxAsDecimal(value)
    }
    return nil
  }

  private func boxAsDate<T: Encodable>(_ value: T) throws -> NSObject? {
    guard let date = value as? Date else {
      return nil
    }
    return try self.box(date)
  }

  private func boxAsData<T: Encodable>(_ value: T) throws -> NSObject? {
    guard let data = value as? Data else {
      return nil
    }
    return try self.box(data)
  }

  private func boxAsURL<T: Encodable>(_ value: T) -> NSObject? {
    guard let url = value as? URL else {
      return nil
    }
    return self.box(url.absoluteString)
  }

  private func boxAsDecimal<T: Encodable>(_ value: T) -> NSObject? {
    if let decimal = value as? NSDecimalNumber {
      // DictionarySerialization can natively handle NSDecimalNumber.
      return decimal
    }
    // On Linux, Swift Decimal doesn't auto-bridge to NSDecimalNumber.
    if let decimal = value as? Decimal {
      return NSDecimalNumber(decimal: decimal)
    }
    return nil
  }

  private func boxGenericEncodable<T: Encodable>(_ value: T) throws -> NSObject? {
    // The value should request a container from the DictionaryEncoderImpl.
    let depth = self.storage.count
    do {
      try value.encode(to: self)
    } catch {
      // If the value pushed a container before throwing, pop it back off to
      // restore state.
      if self.storage.count > depth {
        _ = self.storage.popContainer()
      }
      throw error
    }

    // The top container should be a new container.
    guard self.storage.count > depth else {
      return nil
    }

    return self.storage.popContainer()
  }
}
