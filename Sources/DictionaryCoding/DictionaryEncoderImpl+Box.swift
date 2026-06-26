//
//  DictionaryEncoderImpl+Box.swift
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

// MARK: - Concrete Value Representations
extension DictionaryEncoderImpl {
  /// Returns the given value boxed in a container appropriate for pushing
  /// onto the container stack.
  internal func box(_ value: Bool) -> NSObject { NSNumber(value: value) }
  internal func box(_ value: Int) -> NSObject { NSNumber(value: value) }
  internal func box(_ value: Int8) -> NSObject { NSNumber(value: value) }
  internal func box(_ value: Int16) -> NSObject { NSNumber(value: value) }
  internal func box(_ value: Int32) -> NSObject { NSNumber(value: value) }
  internal func box(_ value: Int64) -> NSObject { NSNumber(value: value) }
  internal func box(_ value: UInt) -> NSObject { NSNumber(value: value) }
  internal func box(_ value: UInt8) -> NSObject { NSNumber(value: value) }
  internal func box(_ value: UInt16) -> NSObject { NSNumber(value: value) }
  internal func box(_ value: UInt32) -> NSObject { NSNumber(value: value) }
  internal func box(_ value: UInt64) -> NSObject { NSNumber(value: value) }
  internal func box(_ value: String) -> NSObject { NSString(string: value) }

  internal func box(_ float: Float) throws -> NSObject {
    guard !float.isInfinite && !float.isNaN else {
      return try boxNonConformingFloat(float)
    }
    return NSNumber(value: float)
  }

  private func boxNonConformingFloat(_ float: Float) throws -> NSObject {
    guard
      case .convertToString(
        positiveInfinity: let posInfString,
        negativeInfinity: let negInfString,
        nan: let nanString
      ) = self.options.nonConformingFloatEncodingStrategy
    else {
      throw EncodingError.invalidFloatingPointValue(float, at: codingPath)
    }

    if float == Float.infinity {
      return NSString(string: posInfString)
    } else if float == -Float.infinity {
      return NSString(string: negInfString)
    } else {
      return NSString(string: nanString)
    }
  }

  internal func box(_ double: Double) throws -> NSObject {
    guard !double.isInfinite && !double.isNaN else {
      return try boxNonConformingDouble(double)
    }
    return NSNumber(value: double)
  }

  private func boxNonConformingDouble(_ double: Double) throws -> NSObject {
    guard
      case .convertToString(
        positiveInfinity: let posInfString,
        negativeInfinity: let negInfString,
        nan: let nanString
      ) = self.options.nonConformingFloatEncodingStrategy
    else {
      throw EncodingError.invalidFloatingPointValue(double, at: codingPath)
    }

    if double == Double.infinity {
      return NSString(string: posInfString)
    } else if double == -Double.infinity {
      return NSString(string: negInfString)
    } else {
      return NSString(string: nanString)
    }
  }

  internal func box(_ date: Date) throws -> NSObject {
    switch self.options.dateEncodingStrategy {
    case .deferredToDate:
      return try boxDateDeferred(date)
    case .secondsSince1970:
      return NSNumber(value: date.timeIntervalSince1970)
    case .millisecondsSince1970:
      return NSNumber(value: 1_000.0 * date.timeIntervalSince1970)
    case .iso8601:
      return boxDateISO8601(date)
    case .formatted(let formatter):
      return NSString(string: formatter.string(from: date))
    case .custom(let closure):
      return try boxDateCustom(date, closure: closure)
    }
  }

  private func boxDateDeferred(_ date: Date) throws -> NSObject {
    // Must be called with a surrounding with(pushedKey:) call.
    // Dates encode as single-value objects; this can't both throw and push a
    // container, so no need to catch the error.
    try date.encode(to: self)
    return self.storage.popContainer()
  }

  private func boxDateISO8601(_ date: Date) -> NSObject {
    NSString(string: date.formatted(.iso8601))
  }

  private func boxDateCustom(
    _ date: Date,
    closure: (Date, Encoder) throws -> Void
  ) throws -> NSObject {
    let depth = self.storage.count
    do {
      try closure(date, self)
    } catch {
      if self.storage.count > depth {
        _ = self.storage.popContainer()
      }
      throw error
    }

    guard self.storage.count > depth else {
      return NSDictionary()
    }

    return self.storage.popContainer()
  }

  internal func box(_ data: Data) throws -> NSObject {
    switch self.options.dataEncodingStrategy {
    case .deferredToData:
      return try boxDataDeferred(data)
    case .base64:
      return NSString(string: data.base64EncodedString())
    case .custom(let closure):
      return try boxDataCustom(data, closure: closure)
    }
  }

  private func boxDataDeferred(_ data: Data) throws -> NSObject {
    // Must be called with a surrounding with(pushedKey:) call.
    let depth = self.storage.count
    do {
      try data.encode(to: self)
    } catch {
      if self.storage.count > depth {
        _ = self.storage.popContainer()
      }
      throw error
    }
    return self.storage.popContainer()
  }

  private func boxDataCustom(
    _ data: Data,
    closure: (Data, Encoder) throws -> Void
  ) throws -> NSObject {
    let depth = self.storage.count
    do {
      try closure(data, self)
    } catch {
      if self.storage.count > depth {
        _ = self.storage.popContainer()
      }
      throw error
    }

    guard self.storage.count > depth else {
      return NSDictionary()
    }

    return self.storage.popContainer()
  }
}
