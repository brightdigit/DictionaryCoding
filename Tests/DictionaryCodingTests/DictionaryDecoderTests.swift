//
//  DictionaryDecoderTests.swift
//  AtLeast
//
//  Copyright (c) 2026 BrightDigit.
//  All rights reserved.
//

import DictionaryCoding
import Foundation
import Testing

@Suite("DictionaryDecoder")
internal struct DictionaryDecoderTests {
  private struct Simple: Codable, Equatable {
    let name: String
    let count: Int
  }

  private struct WithOptional: Codable, Equatable {
    let value: String?
  }

  @Test("decodes string and int from dictionary")
  internal func decodesSimpleFields() throws {
    let dict: [String: Any] = ["name": "world", "count": 7]
    let result = try DictionaryDecoder().decode(Simple.self, from: dict)
    #expect(result.name == "world")
    #expect(result.count == 7)
  }

  @Test("decodes present optional")
  internal func decodesPresentOptional() throws {
    let dict: [String: Any] = ["value": "here"]
    let result = try DictionaryDecoder().decode(WithOptional.self, from: dict)
    #expect(result.value == "here")
  }

  @Test("decodes missing key as nil optional")
  internal func decodesMissingKeyAsNil() throws {
    let dict: [String: Any] = [:]
    let result = try DictionaryDecoder().decode(WithOptional.self, from: dict)
    #expect(result.value == nil)
  }

  @Test("throws on missing required key")
  internal func throwsOnMissingKey() {
    let dict: [String: Any] = ["name": "only"]
    #expect(throws: (any Error).self) {
      try DictionaryDecoder().decode(Simple.self, from: dict)
    }
  }
}
