//
//  DictionaryCodingNestedTests.swift
//  AtLeast
//
//  Copyright (c) 2026 BrightDigit.
//  All rights reserved.
//

import DictionaryCoding
import Foundation
import Testing

@Suite("DictionaryCoding nested containers")
internal struct DictionaryCodingNestedTests {
  private struct NestedItem: Codable, Equatable {
    let name: String
    let value: Int
  }

  private struct ArrayOfObjects: Codable, Equatable {
    let items: [NestedItem]
  }

  private struct NestedArrays: Codable, Equatable {
    let grid: [[Int]]
  }

  private struct Level3: Codable, Equatable {
    let label: String
  }

  private struct Level2: Codable, Equatable {
    let child: Level3
  }

  private struct Level1: Codable, Equatable {
    let nested: Level2
  }

  private struct KeyedArray: Codable, Equatable {
    let tags: [String]
  }

  @Test("round-trips array of objects")
  internal func arrayOfObjects() throws {
    let original = ArrayOfObjects(items: [
      NestedItem(name: "a", value: 1),
      NestedItem(name: "b", value: 2),
    ])
    let dict: [String: Any] = try DictionaryEncoder().encode(original)
    let decoded = try DictionaryDecoder().decode(
      ArrayOfObjects.self, from: dict
    )
    #expect(decoded == original)
  }

  @Test("round-trips nested arrays")
  internal func nestedArrays() throws {
    let original = NestedArrays(grid: [[1, 2], [3, 4, 5], []])
    let dict: [String: Any] = try DictionaryEncoder().encode(original)
    let decoded = try DictionaryDecoder().decode(
      NestedArrays.self, from: dict
    )
    #expect(decoded == original)
  }

  @Test("round-trips deeply nested structs")
  internal func deeplyNestedStruct() throws {
    let original = Level1(
      nested: Level2(child: Level3(label: "deep"))
    )
    let dict: [String: Any] = try DictionaryEncoder().encode(original)
    let decoded = try DictionaryDecoder().decode(
      Level1.self, from: dict
    )
    #expect(decoded == original)
  }

  @Test("keyed container with array value")
  internal func keyedArrayRoundTrip() throws {
    let original = KeyedArray(tags: ["swift", "testing", "codable"])
    let dict: [String: Any] = try DictionaryEncoder().encode(original)
    let decoded = try DictionaryDecoder().decode(
      KeyedArray.self, from: dict
    )
    #expect(decoded == original)
  }

  @Test("encode returns NSDictionary via overload")
  internal func encodeToNSDictionary() throws {
    let original = NestedItem(name: "test", value: 42)
    let nsDict: NSDictionary = try DictionaryEncoder().encode(original)
    let name = try #require(nsDict["name"] as? String)
    let value = try #require(nsDict["value"] as? Int)
    #expect(name == "test")
    #expect(value == 42)
  }
}
