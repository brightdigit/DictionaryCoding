//
//  DictionaryUnkeyedDecodingContainer+UnsignedScalars.swift
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

// MARK: - Unsigned integer scalar decode methods
extension DictionaryUnkeyedDecodingContainer {
  internal mutating func decode(_ type: UInt.Type) throws -> UInt {
    guard !self.isAtEnd else {
      throw atEndError(type)
    }

    self.decoder.codingPath.append(DictionaryCodingKey(index: self.currentIndex))
    defer { self.decoder.codingPath.removeLast() }

    guard
      let decoded =
        try self.decoder.unbox(self.container[self.currentIndex], as: UInt.self)
    else {
      throw nullFoundError(type)
    }

    self.currentIndex += 1
    return decoded
  }

  internal mutating func decode(_ type: UInt8.Type) throws -> UInt8 {
    guard !self.isAtEnd else {
      throw atEndError(type)
    }

    self.decoder.codingPath.append(DictionaryCodingKey(index: self.currentIndex))
    defer { self.decoder.codingPath.removeLast() }

    guard
      let decoded =
        try self.decoder.unbox(self.container[self.currentIndex], as: UInt8.self)
    else {
      throw nullFoundError(type)
    }

    self.currentIndex += 1
    return decoded
  }

  internal mutating func decode(_ type: UInt16.Type) throws -> UInt16 {
    guard !self.isAtEnd else {
      throw atEndError(type)
    }

    self.decoder.codingPath.append(DictionaryCodingKey(index: self.currentIndex))
    defer { self.decoder.codingPath.removeLast() }

    guard
      let decoded =
        try self.decoder.unbox(self.container[self.currentIndex], as: UInt16.self)
    else {
      throw nullFoundError(type)
    }

    self.currentIndex += 1
    return decoded
  }

  internal mutating func decode(_ type: UInt32.Type) throws -> UInt32 {
    guard !self.isAtEnd else {
      throw atEndError(type)
    }

    self.decoder.codingPath.append(DictionaryCodingKey(index: self.currentIndex))
    defer { self.decoder.codingPath.removeLast() }

    guard
      let decoded =
        try self.decoder.unbox(self.container[self.currentIndex], as: UInt32.self)
    else {
      throw nullFoundError(type)
    }

    self.currentIndex += 1
    return decoded
  }

  internal mutating func decode(_ type: UInt64.Type) throws -> UInt64 {
    guard !self.isAtEnd else {
      throw atEndError(type)
    }

    self.decoder.codingPath.append(DictionaryCodingKey(index: self.currentIndex))
    defer { self.decoder.codingPath.removeLast() }

    guard
      let decoded =
        try self.decoder.unbox(self.container[self.currentIndex], as: UInt64.self)
    else {
      throw nullFoundError(type)
    }

    self.currentIndex += 1
    return decoded
  }
}
