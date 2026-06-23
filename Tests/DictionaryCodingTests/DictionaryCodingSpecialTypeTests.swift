//
//  DictionaryCodingSpecialTypeTests.swift
//  AtLeast
//
//  Copyright (c) 2026 BrightDigit.
//  All rights reserved.
//

import DictionaryCoding
import Foundation
import Testing

@Suite("DictionaryCoding special types")
internal struct DictionaryCodingSpecialTypeTests {
  private struct WithURL: Codable, Equatable { let link: URL }
  private struct WithDecimal: Codable, Equatable { let amount: Decimal }
  private struct WithUUID: Codable, Equatable { let identifier: UUID }

  private enum Compass: String, Codable, Equatable {
    case north, south, east, west
  }

  private struct WithCompass: Codable, Equatable {
    let direction: Compass
  }

  private enum Status: Codable, Equatable {
    case idle
    case running(progress: Double)
    case finished(message: String)
  }

  private struct WithStatus: Codable, Equatable {
    let status: Status
  }

  @Test("round-trips URL value")
  internal func urlRoundTrip() throws {
    let url = try #require(URL(string: "https://example.com/path"))
    let original = WithURL(link: url)
    let dict: [String: Any] = try DictionaryEncoder().encode(original)
    let decoded = try DictionaryDecoder().decode(
      WithURL.self, from: dict
    )
    #expect(decoded == original)
  }

  @Test("round-trips Decimal value")
  internal func decimalRoundTrip() throws {
    let decimal = try #require(Decimal(string: "123.456"))
    let original = WithDecimal(amount: decimal)
    let dict: [String: Any] = try DictionaryEncoder().encode(original)
    let decoded = try DictionaryDecoder().decode(
      WithDecimal.self, from: dict
    )
    #expect(decoded == original)
  }

  @Test("round-trips UUID value")
  internal func uuidRoundTrip() throws {
    let original = WithUUID(identifier: UUID())
    let dict: [String: Any] = try DictionaryEncoder().encode(original)
    let decoded = try DictionaryDecoder().decode(
      WithUUID.self, from: dict
    )
    #expect(decoded == original)
  }

  @Test("round-trips enum with associated values")
  internal func enumWithAssociatedValues() throws {
    let cases: [WithStatus] = [
      WithStatus(status: .idle),
      WithStatus(status: .running(progress: 0.75)),
      WithStatus(status: .finished(message: "done")),
    ]
    for original in cases {
      let dict: [String: Any] = try DictionaryEncoder().encode(original)
      let decoded = try DictionaryDecoder().decode(
        WithStatus.self, from: dict
      )
      #expect(decoded == original)
    }
  }

  @Test("raw-value enum round-trips")
  internal func rawValueEnumRoundTrip() throws {
    let original = WithCompass(direction: .east)
    let dict: [String: Any] = try DictionaryEncoder().encode(original)
    let decoded = try DictionaryDecoder().decode(
      WithCompass.self, from: dict
    )
    #expect(decoded == original)
  }
}
