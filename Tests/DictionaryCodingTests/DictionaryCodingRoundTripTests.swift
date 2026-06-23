//
//  DictionaryCodingRoundTripTests.swift
//  AtLeast
//
//  Copyright (c) 2026 BrightDigit.
//  All rights reserved.
//

import DictionaryCoding
import Foundation
import Testing

@Suite("DictionaryCoding round-trip")
internal struct DictionaryCodingRoundTripTests {
  private struct AllTypes: Codable, Equatable {
    let text: String
    let number: Int
    let decimal: Double
    let flag: Bool
    let optional: String?
  }

  private struct WithDate: Codable, Equatable {
    let timestamp: Date
  }

  @Test("round-trips struct with all primitive types")
  internal func roundTripsAllPrimitives() throws {
    let original = AllTypes(
      text: "abc", number: -5, decimal: 2.718, flag: false, optional: nil
    )
    let dict: [String: Any] = try DictionaryEncoder().encode(original)
    let decoded = try DictionaryDecoder().decode(AllTypes.self, from: dict)
    #expect(decoded == original)
  }

  @Test("round-trips struct with present optional")
  internal func roundTripsPresentOptional() throws {
    let original = AllTypes(text: "x", number: 0, decimal: 0, flag: true, optional: "set")
    let dict: [String: Any] = try DictionaryEncoder().encode(original)
    let decoded = try DictionaryDecoder().decode(AllTypes.self, from: dict)
    #expect(decoded == original)
  }

  @Test("round-trips Date via secondsSince1970 strategy")
  internal func roundTripsDate() throws {
    let date = Date(timeIntervalSince1970: 1_700_000_000)
    let original = WithDate(timestamp: date)
    let encoder = DictionaryEncoder()
    encoder.dateEncodingStrategy = .secondsSince1970
    let decoder = DictionaryDecoder()
    decoder.dateDecodingStrategy = .secondsSince1970
    let dict: [String: Any] = try encoder.encode(original)
    let decoded = try decoder.decode(WithDate.self, from: dict)
    #expect(decoded == original)
  }
}
