//
//  DictionaryCodingStrategyErrorTests.swift
//  AtLeast
//
//  Copyright (c) 2026 BrightDigit.
//  All rights reserved.
//

import DictionaryCoding
import Foundation
import Testing

@Suite("DictionaryCoding strategy error paths")
internal struct DictionaryCodingStrategyErrorTests {
  private struct WithDate: Codable { let timestamp: Date }

  private struct WithData: Codable, Equatable {
    let payload: Data
  }

  // MARK: - Formatted Date Failure

  @Test("throws on malformed date with formatted strategy")
  internal func formattedDateFailure() {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    formatter.locale = Locale(identifier: "en_US_POSIX")

    let dict: [String: Any] = ["timestamp": "not-a-date"]
    let decoder = DictionaryDecoder()
    decoder.dateDecodingStrategy = .formatted(formatter)
    #expect(throws: DecodingError.self) {
      try decoder.decode(WithDate.self, from: dict)
    }
  }

  // MARK: - Invalid Base64

  @Test("throws on invalid base64 with base64 strategy")
  internal func invalidBase64() {
    let dict: [String: Any] = ["payload": "!!!invalid!!!"]
    let decoder = DictionaryDecoder()
    decoder.dataDecodingStrategy = .base64
    #expect(throws: DecodingError.self) {
      try decoder.decode(WithData.self, from: dict)
    }
  }

  // MARK: - Deferred Strategies

  @Test("deferredToData round-trips")
  internal func deferredToDataRoundTrip() throws {
    let original = WithData(payload: Data([0xDE, 0xAD]))
    let encoder = DictionaryEncoder()
    encoder.dataEncodingStrategy = .deferredToData
    let decoder = DictionaryDecoder()
    decoder.dataDecodingStrategy = .deferredToData
    let dict: [String: Any] = try encoder.encode(original)
    let decoded = try decoder.decode(WithData.self, from: dict)
    #expect(decoded == original)
  }

  @Test("deferredToDate round-trips")
  internal func deferredToDateRoundTrip() throws {
    let date = Date(timeIntervalSince1970: 1_700_000_000)
    let original = WithDate(timestamp: date)
    let encoder = DictionaryEncoder()
    encoder.dateEncodingStrategy = .deferredToDate
    let decoder = DictionaryDecoder()
    decoder.dateDecodingStrategy = .deferredToDate
    let dict: [String: Any] = try encoder.encode(original)
    let decoded = try decoder.decode(WithDate.self, from: dict)
    let diff = abs(
      decoded.timestamp.timeIntervalSince1970
        - date.timeIntervalSince1970
    )
    #expect(diff < 0.001)
  }
}
