//
//  DictionaryCodingSuperDecoderTests.swift
//  AtLeast
//
//  Copyright (c) 2026 BrightDigit.
//  All rights reserved.
//

import DictionaryCoding
import Foundation
import Testing

@Suite("DictionaryCoding superDecoder and key strategies")
internal struct DictionaryCodingSuperDecoderTests {
  private struct PrefixModel: Codable, Equatable {
    let name: String
    let age: Int
  }

  // MARK: - SuperDecoder Tests

  @Test("round-trips class hierarchy using superDecoder")
  internal func superDecoderRoundTrip() throws {
    let original = SuperDecoderChild(
      baseValue: 10, childValue: "hello"
    )
    let dict: [String: Any] = try DictionaryEncoder().encode(original)
    let decoded = try DictionaryDecoder().decode(
      SuperDecoderChild.self, from: dict
    )
    #expect(decoded.baseValue == 10)
    #expect(decoded.childValue == "hello")
  }

  @Test("superDecoder from manual dictionary")
  internal func superDecoderFromManualDict() throws {
    let dict: [String: Any] = [
      "childValue": "world",
      "super": ["baseValue": 42] as [String: Any],
    ]
    let decoded = try DictionaryDecoder().decode(
      SuperDecoderChild.self, from: dict
    )
    #expect(decoded.baseValue == 42)
    #expect(decoded.childValue == "world")
  }

  // MARK: - Custom Key Strategies

  @Test("custom key encoding applies prefix")
  internal func customKeyEncoding() throws {
    let encoder = DictionaryEncoder()
    encoder.keyEncodingStrategy = .custom { path in
      let key = path[path.count - 1].stringValue
      return DictionaryCodingTestKey(
        stringValue: "pfx_\(key)"
      )
    }
    let value = PrefixModel(name: "Test", age: 25)
    let dict: [String: Any] = try encoder.encode(value)
    #expect(dict["pfx_name"] as? String == "Test")
    #expect(dict["pfx_age"] as? Int == 25)
  }

  @Test("custom key decoding strips prefix")
  internal func customKeyDecoding() throws {
    let dict: [String: Any] = [
      "pfx_name": "Test", "pfx_age": 25,
    ]
    let decoder = DictionaryDecoder()
    decoder.keyDecodingStrategy = .custom { path in
      let key = path[path.count - 1].stringValue
      let stripped = key.replacingOccurrences(
        of: "pfx_", with: ""
      )
      return DictionaryCodingTestKey(stringValue: stripped)
    }
    let result = try decoder.decode(PrefixModel.self, from: dict)
    #expect(result.name == "Test")
    #expect(result.age == 25)
  }
}
