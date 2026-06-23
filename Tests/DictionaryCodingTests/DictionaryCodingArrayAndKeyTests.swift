//
//  DictionaryCodingArrayAndKeyTests.swift
//  AtLeast
//
//  Copyright (c) 2026 BrightDigit.
//  All rights reserved.
//

import DictionaryCoding
import Foundation
import Testing

@Suite("DictionaryCoding array and key strategies")
internal struct DictionaryCodingArrayAndKeyTests {
  private struct WithArray: Codable, Equatable {
    let items: [String]
  }

  private struct WithIntArray: Codable, Equatable {
    let values: [Int]
  }

  private struct CamelCaseModel: Codable, Equatable {
    let firstName: String
    let lastName: String
    let itemCount: Int
  }

  @Test("encodes and decodes array of strings")
  internal func roundTripsStringArray() throws {
    let original = WithArray(items: ["alpha", "beta", "gamma"])
    let dict: [String: Any] = try DictionaryEncoder().encode(original)
    let decoded = try DictionaryDecoder().decode(WithArray.self, from: dict)
    #expect(decoded == original)
  }

  @Test("encodes and decodes empty array")
  internal func roundTripsEmptyArray() throws {
    let original = WithArray(items: [])
    let dict: [String: Any] = try DictionaryEncoder().encode(original)
    let decoded = try DictionaryDecoder().decode(WithArray.self, from: dict)
    #expect(decoded == original)
  }

  @Test("encodes and decodes array of ints")
  internal func roundTripsIntArray() throws {
    let original = WithIntArray(values: [1, 2, 3, -7])
    let dict: [String: Any] = try DictionaryEncoder().encode(original)
    let decoded = try DictionaryDecoder().decode(WithIntArray.self, from: dict)
    #expect(decoded == original)
  }

  @Test("encoder convertToSnakeCase converts camelCase keys to snake_case")
  internal func encoderConvertToSnakeCase() throws {
    let value = CamelCaseModel(firstName: "Jane", lastName: "Doe", itemCount: 3)
    let encoder = DictionaryEncoder()
    encoder.keyEncodingStrategy = .convertToSnakeCase
    let dict: [String: Any] = try encoder.encode(value)
    #expect(dict["first_name"] as? String == "Jane")
    #expect(dict["last_name"] as? String == "Doe")
    #expect(dict["item_count"] as? Int == 3)
  }

  @Test("decoder convertFromSnakeCase converts snake_case keys to camelCase")
  internal func decoderConvertFromSnakeCase() throws {
    let dict: [String: Any] = [
      "first_name": "Jane",
      "last_name": "Doe",
      "item_count": 3,
    ]
    let decoder = DictionaryDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    let result = try decoder.decode(CamelCaseModel.self, from: dict)
    #expect(result.firstName == "Jane")
    #expect(result.lastName == "Doe")
    #expect(result.itemCount == 3)
  }

  @Test("snake_case round-trip with both strategies")
  internal func snakeCaseRoundTrip() throws {
    let original = CamelCaseModel(firstName: "Alice", lastName: "Smith", itemCount: 10)
    let encoder = DictionaryEncoder()
    encoder.keyEncodingStrategy = .convertToSnakeCase
    let decoder = DictionaryDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    let dict: [String: Any] = try encoder.encode(original)
    let decoded = try decoder.decode(CamelCaseModel.self, from: dict)
    #expect(decoded == original)
  }
}
