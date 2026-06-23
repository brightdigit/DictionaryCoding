//
//  DictionaryUnkeyedDecodingContainer+String.swift
//  AtLeast
//
//  Copyright (c) 2026 BrightDigit.
//  All rights reserved.
//

import Foundation

// MARK: - String decode
extension DictionaryUnkeyedDecodingContainer {
  internal mutating func decode(_ type: String.Type) throws -> String {
    guard !self.isAtEnd else {
      throw atEndError(type)
    }

    self.decoder.codingPath.append(DictionaryCodingKey(index: self.currentIndex))
    defer { self.decoder.codingPath.removeLast() }

    guard
      let decoded =
        try self.decoder.unbox(self.container[self.currentIndex], as: String.self)
    else {
      throw nullFoundError(type)
    }

    self.currentIndex += 1
    return decoded
  }
}
