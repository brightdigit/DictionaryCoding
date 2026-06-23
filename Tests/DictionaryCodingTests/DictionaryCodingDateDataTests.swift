//
//  DictionaryCodingDateDataTests.swift
//  AtLeast
//
//  Copyright (c) 2026 BrightDigit.
//  All rights reserved.
//

import DictionaryCoding
import Foundation
import Testing

@Suite("DictionaryCoding date, data and missing value strategies")
internal struct DictionaryCodingDateDataTests {
  private struct WithDate: Codable, Equatable {
    let timestamp: Date
  }

  private struct WithData: Codable, Equatable {
    let payload: Data
  }

  private struct WithAllScalars: Codable, Equatable {
    let name: String
    let number: Int
    let ratio: Double
    let flag: Bool
  }

  @Test("millisecondsSince1970 round-trip")
  internal func millisecondsSince1970RoundTrip() throws {
    let date = Date(timeIntervalSince1970: 1_700_000_000)
    let original = WithDate(timestamp: date)
    let encoder = DictionaryEncoder()
    encoder.dateEncodingStrategy = .millisecondsSince1970
    let decoder = DictionaryDecoder()
    decoder.dateDecodingStrategy = .millisecondsSince1970
    let dict: [String: Any] = try encoder.encode(original)
    let decoded = try decoder.decode(WithDate.self, from: dict)
    let expected = date.timeIntervalSince1970
    let actual = decoded.timestamp.timeIntervalSince1970
    #expect(abs(actual - expected) < 0.001)
  }

  @Test("iso8601 round-trip")
  internal func iso8601RoundTrip() throws {
    guard #available(macOS 10.12, iOS 10.0, watchOS 3.0, tvOS 10.0, *) else {
      return
    }
    let date = Date(timeIntervalSince1970: 1_700_000_000)
    let original = WithDate(timestamp: date)
    let encoder = DictionaryEncoder()
    encoder.dateEncodingStrategy = .iso8601
    let decoder = DictionaryDecoder()
    decoder.dateDecodingStrategy = .iso8601
    let dict: [String: Any] = try encoder.encode(original)
    let decoded = try decoder.decode(WithDate.self, from: dict)
    let expected = date.timeIntervalSince1970
    let actual = decoded.timestamp.timeIntervalSince1970
    #expect(abs(actual - expected) < 1.0)
  }

  @Test("base64 Data round-trip")
  internal func base64DataRoundTrip() throws {
    let bytes = Data([0x01, 0x02, 0xFF, 0xAB])
    let original = WithData(payload: bytes)
    let dict: [String: Any] = try DictionaryEncoder().encode(original)
    let decoded = try DictionaryDecoder().decode(WithData.self, from: dict)
    #expect(decoded == original)
  }

  @Test("useStandardDefault fills missing keys with zero values")
  internal func useStandardDefaultFillsMissingKeys() throws {
    let dict: [String: Any] = [:]
    let decoder = DictionaryDecoder()
    decoder.missingValueDecodingStrategy = .useStandardDefault
    let result = try decoder.decode(WithAllScalars.self, from: dict)
    #expect(result.name.isEmpty)
    #expect(result.number == 0)
    #expect(result.ratio == 0.0)
    #expect(result.flag == false)
  }

  @Test("useDefault fills missing keys from provided defaults")
  internal func useDefaultFillsMissingKeysFromDefaults() throws {
    let dict: [String: Any] = [:]
    let decoder = DictionaryDecoder()
    decoder.missingValueDecodingStrategy = .useDefault(
      defaults: ["String": "fallback", "Int": 99, "Double": 3.14, "Bool": true]
    )
    let result = try decoder.decode(WithAllScalars.self, from: dict)
    #expect(result.name == "fallback")
    #expect(result.number == 99)
    #expect(abs(result.ratio - 3.14) < 0.001)
    #expect(result.flag == true)
  }
}
