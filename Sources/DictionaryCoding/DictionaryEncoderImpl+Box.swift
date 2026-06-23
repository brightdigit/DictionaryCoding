//
//  DictionaryEncoderImpl+Box.swift
//  AtLeast
//
//  Copyright (c) 2026 BrightDigit.
//  All rights reserved.
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
      case let .convertToString(
        positiveInfinity: posInfString,
        negativeInfinity: negInfString,
        nan: nanString
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
      case let .convertToString(
        positiveInfinity: posInfString,
        negativeInfinity: negInfString,
        nan: nanString
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
