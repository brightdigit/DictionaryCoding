//
//  DictionaryUnkeyedDecodingContainer+Scalars.swift
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

// MARK: - Scalar decode methods
extension DictionaryUnkeyedDecodingContainer {
  internal mutating func decode(_ type: Bool.Type) throws -> Bool {
    guard !self.isAtEnd else {
      throw atEndError(type)
    }

    self.decoder.codingPath.append(DictionaryCodingKey(index: self.currentIndex))
    defer { self.decoder.codingPath.removeLast() }

    guard
      let decoded =
        try self.decoder.unbox(self.container[self.currentIndex], as: Bool.self)
    else {
      throw nullFoundError(type)
    }

    self.currentIndex += 1
    return decoded
  }

  internal mutating func decode(_ type: Int.Type) throws -> Int {
    guard !self.isAtEnd else {
      throw atEndError(type)
    }

    self.decoder.codingPath.append(DictionaryCodingKey(index: self.currentIndex))
    defer { self.decoder.codingPath.removeLast() }

    guard
      let decoded =
        try self.decoder.unbox(self.container[self.currentIndex], as: Int.self)
    else {
      throw nullFoundError(type)
    }

    self.currentIndex += 1
    return decoded
  }

  internal mutating func decode(_ type: Int8.Type) throws -> Int8 {
    guard !self.isAtEnd else {
      throw atEndError(type)
    }

    self.decoder.codingPath.append(DictionaryCodingKey(index: self.currentIndex))
    defer { self.decoder.codingPath.removeLast() }

    guard
      let decoded =
        try self.decoder.unbox(self.container[self.currentIndex], as: Int8.self)
    else {
      throw nullFoundError(type)
    }

    self.currentIndex += 1
    return decoded
  }

  internal mutating func decode(_ type: Int16.Type) throws -> Int16 {
    guard !self.isAtEnd else {
      throw atEndError(type)
    }

    self.decoder.codingPath.append(DictionaryCodingKey(index: self.currentIndex))
    defer { self.decoder.codingPath.removeLast() }

    guard
      let decoded =
        try self.decoder.unbox(self.container[self.currentIndex], as: Int16.self)
    else {
      throw nullFoundError(type)
    }

    self.currentIndex += 1
    return decoded
  }

  internal mutating func decode(_ type: Int32.Type) throws -> Int32 {
    guard !self.isAtEnd else {
      throw atEndError(type)
    }

    self.decoder.codingPath.append(DictionaryCodingKey(index: self.currentIndex))
    defer { self.decoder.codingPath.removeLast() }

    guard
      let decoded =
        try self.decoder.unbox(self.container[self.currentIndex], as: Int32.self)
    else {
      throw nullFoundError(type)
    }

    self.currentIndex += 1
    return decoded
  }

  internal mutating func decode(_ type: Int64.Type) throws -> Int64 {
    guard !self.isAtEnd else {
      throw atEndError(type)
    }

    self.decoder.codingPath.append(DictionaryCodingKey(index: self.currentIndex))
    defer { self.decoder.codingPath.removeLast() }

    guard
      let decoded =
        try self.decoder.unbox(self.container[self.currentIndex], as: Int64.self)
    else {
      throw nullFoundError(type)
    }

    self.currentIndex += 1
    return decoded
  }

  internal mutating func decode(_ type: Float.Type) throws -> Float {
    guard !self.isAtEnd else {
      throw atEndError(type)
    }

    self.decoder.codingPath.append(DictionaryCodingKey(index: self.currentIndex))
    defer { self.decoder.codingPath.removeLast() }

    guard
      let decoded =
        try self.decoder.unbox(self.container[self.currentIndex], as: Float.self)
    else {
      throw nullFoundError(type)
    }

    self.currentIndex += 1
    return decoded
  }

  internal mutating func decode(_ type: Double.Type) throws -> Double {
    guard !self.isAtEnd else {
      throw atEndError(type)
    }

    self.decoder.codingPath.append(DictionaryCodingKey(index: self.currentIndex))
    defer { self.decoder.codingPath.removeLast() }

    guard
      let decoded =
        try self.decoder.unbox(self.container[self.currentIndex], as: Double.self)
    else {
      throw nullFoundError(type)
    }

    self.currentIndex += 1
    return decoded
  }
}
