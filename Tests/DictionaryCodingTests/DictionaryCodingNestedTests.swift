//
//  DictionaryCodingNestedTests.swift
//  DictionaryCoding
//
//  Created by Leo Dion.
//  Copyright © 2026 BrightDigit.
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or
//  sell copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
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
