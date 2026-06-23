//
//  DictionaryCodingTestKey.swift
//  AtLeast
//
//  Copyright (c) 2026 BrightDigit.
//  All rights reserved.
//

/// A simple CodingKey used by custom key strategy tests.
internal struct DictionaryCodingTestKey: CodingKey {
  internal var stringValue: String
  internal var intValue: Int?

  internal init(stringValue: String) {
    self.stringValue = stringValue
    self.intValue = nil
  }

  internal init?(intValue: Int) {
    self.stringValue = "\(intValue)"
    self.intValue = intValue
  }
}
