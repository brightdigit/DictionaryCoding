//
//  DictionaryCodingArrayAndKeyTests.swift
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
