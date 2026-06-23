//
//  DictionaryCodingKey.swift
//  AtLeast
//
//  Copyright (c) 2026 BrightDigit.
//  All rights reserved.
//

import Foundation

internal struct DictionaryCodingKey: CodingKey {
  internal static let `super` = DictionaryCodingKey(stringValue: "super", intValue: nil)

  internal var stringValue: String
  internal var intValue: Int?

  internal init?(stringValue: String) {
    self.stringValue = stringValue
    intValue = nil
  }

  internal init?(intValue: Int) {
    stringValue = "\(intValue)"
    self.intValue = intValue
  }

  internal init(stringValue: String, intValue: Int?) {
    self.stringValue = stringValue
    self.intValue = intValue
  }

  internal init(index: Int) {
    stringValue = "Index \(index)"
    intValue = index
  }
}
