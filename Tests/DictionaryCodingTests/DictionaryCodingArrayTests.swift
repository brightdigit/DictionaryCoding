//
//  DictionaryCodingArrayTests.swift
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
    let original = ScalarArrays(int8s: [], uint16s: [], doubles: [], bools: [], strings: [])
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
