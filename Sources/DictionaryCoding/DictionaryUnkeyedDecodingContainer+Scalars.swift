//
//  DictionaryUnkeyedDecodingContainer+Scalars.swift
//  AtLeast
//
//  Copyright (c) 2026 BrightDigit.
//  All rights reserved.
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
