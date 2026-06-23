//
//  DictionaryCodingArrayTests.swift
//  AtLeast
//
//  Copyright (c) 2026 BrightDigit.
//  All rights reserved.
//

import DictionaryCoding
import Foundation
import Testing

@Suite("DictionaryCoding array and optional round-trips")
internal struct DictionaryCodingArrayTests {
  private struct ScalarArrays: Codable, Equatable {
    let int8s: [Int8]
    let uint16s: [UInt16]
    let doubles: [Double]
    let bools: [Bool]
    let strings: [String]
  }

  private struct OptionalIntArray: Codable, Equatable {
    let values: [Int?]
  }

  @Test("round-trips arrays of all scalar types")
  internal func scalarArrays() throws {
    let original = ScalarArrays(
      int8s: [Int8.min, 0, Int8.max],
      uint16s: [0, 1_000, UInt16.max],
      doubles: [-1.5, 0.0, 3.14],
      bools: [true, false, true],
      strings: ["hello", "", "world"]
    )
    let dict: [String: Any] = try DictionaryEncoder().encode(original)
    let decoded = try DictionaryDecoder().decode(
      ScalarArrays.self, from: dict
    )
    #expect(decoded == original)
  }

  @Test("round-trips empty scalar arrays")
  internal func emptyScalarArrays() throws {
    let original = ScalarArrays(
      int8s: [], uint16s: [], doubles: [],
      bools: [], strings: []
    )
    let dict: [String: Any] = try DictionaryEncoder().encode(original)
    let decoded = try DictionaryDecoder().decode(
      ScalarArrays.self, from: dict
    )
    #expect(decoded == original)
  }

  @Test("round-trips array with nil values")
  internal func optionalIntArray() throws {
    let original = OptionalIntArray(values: [1, nil, 3, nil, 5])
    let dict: [String: Any] = try DictionaryEncoder().encode(original)
    let decoded = try DictionaryDecoder().decode(
      OptionalIntArray.self, from: dict
    )
    #expect(decoded == original)
  }
}
