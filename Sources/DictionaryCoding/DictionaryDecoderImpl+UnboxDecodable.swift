//
//  DictionaryDecoderImpl+UnboxDecodable.swift
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

// MARK: - Date, Data, and Decodable unboxing
extension DictionaryDecoderImpl {
  internal func unbox(_ value: Any, as type: Date.Type) throws -> Date? {
    guard !(value is NSNull) else {
      return nil
    }
    return try unboxDate(value)
  }

  private func unboxDate(_ value: Any) throws -> Date? {
    switch self.options.dateDecodingStrategy {
    case .deferredToDate:
      return try unboxDateDeferred(value)
    case .secondsSince1970:
      return try unboxDateTimestamp(value, factor: 1.0)
    case .millisecondsSince1970:
      return try unboxDateTimestamp(value, factor: 1_000.0)
    case .iso8601:
      return try unboxDateISO8601(value)
    case .formatted(let formatter):
      return try unboxDateFormatted(value, formatter: formatter)
    case .custom(let closure):
      return try unboxDateCustom(value, closure: closure)
    }
  }

  private func unboxDateDeferred(_ value: Any) throws -> Date? {
    self.storage.push(container: value)
    defer { self.storage.popContainer() }
    return try Date(from: self)
  }

  private func unboxDateTimestamp(_ value: Any, factor: Double) throws -> Date? {
    guard let double = try self.unbox(value, as: Double.self) else {
      return nil
    }
    return Date(timeIntervalSince1970: double / factor)
  }

  private func unboxDateCustom(
    _ value: Any,
    closure: (Decoder) throws -> Date
  ) throws -> Date? {
    self.storage.push(container: value)
    defer { self.storage.popContainer() }
    return try closure(self)
  }

  private func unboxDateISO8601(_ value: Any) throws -> Date? {
    guard let string = try self.unbox(value, as: String.self) else {
      return nil
    }
    guard let date = try? Date(string, strategy: .iso8601) else {
      throw DecodingError.dataCorrupted(
        DecodingError.Context(
          codingPath: self.codingPath,
          debugDescription: "Expected date string to be ISO8601-formatted."
        )
      )
    }
    return date
  }

  private func unboxDateFormatted(
    _ value: Any,
    formatter: DateFormatter
  ) throws -> Date? {
    guard let string = try self.unbox(value, as: String.self) else {
      return nil
    }
    guard let date = formatter.date(from: string) else {
      throw DecodingError.dataCorrupted(
        DecodingError.Context(
          codingPath: self.codingPath,
          debugDescription:
            "Date string does not match format expected by formatter."
        )
      )
    }
    return date
  }

  internal func unbox(_ value: Any, as type: Data.Type) throws -> Data? {
    guard !(value is NSNull) else {
      return nil
    }

    switch self.options.dataDecodingStrategy {
    case .deferredToData:
      self.storage.push(container: value)
      defer { self.storage.popContainer() }
      return try Data(from: self)

    case .base64:
      guard let string = value as? String else {
        throw DecodingError.typeMismatch(
          at: self.codingPath, expectation: type, reality: value
        )
      }

      guard let data = Data(base64Encoded: string) else {
        throw DecodingError.dataCorrupted(
          DecodingError.Context(
            codingPath: self.codingPath,
            debugDescription: "Encountered Data is not valid Base64."
          )
        )
      }

      return data

    case .custom(let closure):
      self.storage.push(container: value)
      defer { self.storage.popContainer() }
      return try closure(self)
    }
  }

  internal func unbox<T: Decodable>(_ value: Any, as type: T.Type) throws -> T? {
    if let result = try unboxSpecialType(value, as: type) {
      return result
    }
    self.storage.push(container: value)
    defer { self.storage.popContainer() }
    return try type.init(from: self)
  }

  private func unboxSpecialType<T: Decodable>(
    _ value: Any,
    as type: T.Type
  ) throws -> T?? {
    if type == Date.self || type == NSDate.self {
      return try self.unbox(value, as: Date.self) as? T
    } else if type == Data.self || type == NSData.self {
      return try self.unbox(value, as: Data.self) as? T
    } else if isUUIDCompatibleType(type) {
      return try self.unbox(value, as: UUID.self) as? T
    } else if type == URL.self || type == NSURL.self {
      return try unboxURL(value)
    } else if type == Decimal.self || type == NSDecimalNumber.self {
      return try self.unbox(value, as: Decimal.self) as? T
    }
    return nil
  }

  private func isUUIDCompatibleType<T>(_ type: T.Type) -> Bool {
    #if canImport(Darwin)
      return type == UUID.self || type == CFUUID.self
    #else
      return type == UUID.self
    #endif
  }

  private func unboxURL<T>(_ value: Any) throws -> T? {
    guard let urlString = try self.unbox(value, as: String.self) else {
      return nil
    }

    guard let url = URL(string: urlString) else {
      throw DecodingError.dataCorrupted(
        DecodingError.Context(
          codingPath: self.codingPath,
          debugDescription: "Invalid URL string."
        )
      )
    }

    guard let result = url as? T else {
      return nil
    }
    return result
  }
}
