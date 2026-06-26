//
//  DictionaryCodingScalarTests.swift
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

@Suite("DictionaryCoding scalar round-trips")
internal struct DictionaryCodingScalarTests {
  private struct AllIntegers: Codable, Equatable {
    let int: Int
    let int8: Int8
    let int16: Int16
    let int32: Int32
    let int64: Int64
    let uint: UInt
    let uint8: UInt8
    let uint16: UInt16
    let uint32: UInt32
    let uint64: UInt64
  }

  private struct Floats: Codable, Equatable {
    let float: Float
    let double: Double
  }

  private struct BoolModel: Codable, Equatable {
    let flag: Bool
  }

  private struct SmallInt: Codable, Equatable {
    let value: Int8
  }

  @Test("round-trips all integer types")
  internal func allIntegerTypes() throws {
    let original = AllIntegers(
      int: -42,
      int8: Int8.min,
      int16: Int16.max,
      int32: -100_000,
      int64: Int64.max,
      uint: 99,
      uint8: UInt8.max,
      uint16: 0,
      uint32: UInt32.max,
      uint64: UInt64.max
    )
    let dict: [String: Any] = try DictionaryEncoder().encode(original)
    let decoded = try DictionaryDecoder().decode(
      AllIntegers.self, from: dict
    )
    #expect(decoded == original)
  }

  @Test("round-trips integer boundary values")
  internal func integerBoundaries() throws {
    let original = AllIntegers(
      int: Int.min,
      int8: Int8.max,
      int16: Int16.min,
      int32: Int32.max,
      int64: Int64.min,
      uint: UInt.max,
      uint8: 0,
      uint16: UInt16.max,
      uint32: 0,
      uint64: 0
    )
    let dict: [String: Any] = try DictionaryEncoder().encode(original)
    let decoded = try DictionaryDecoder().decode(
      AllIntegers.self, from: dict
    )
    #expect(decoded == original)
  }

  @Test("round-trips float and double")
  internal func floatAndDouble() throws {
    let original = Floats(float: 3.14, double: 2.718281828459045)
    let dict: [String: Any] = try DictionaryEncoder().encode(original)
    let decoded = try DictionaryDecoder().decode(Floats.self, from: dict)
    #expect(decoded == original)
  }

  @Test("round-trips zero floats")
  internal func zeroFloats() throws {
    let original = Floats(float: 0.0, double: 0.0)
    let dict: [String: Any] = try DictionaryEncoder().encode(original)
    let decoded = try DictionaryDecoder().decode(Floats.self, from: dict)
    #expect(decoded == original)
  }

  @Test("round-trips very large float values")
  internal func largeFloats() throws {
    let original = Floats(
      float: Float.greatestFiniteMagnitude,
      double: Double.greatestFiniteMagnitude
    )
    let dict: [String: Any] = try DictionaryEncoder().encode(original)
    let decoded = try DictionaryDecoder().decode(Floats.self, from: dict)
    #expect(decoded == original)
  }

  @Test("round-trips negative floats")
  internal func negativeFloats() throws {
    let original = Floats(float: -1.5, double: -999_999.999)
    let dict: [String: Any] = try DictionaryEncoder().encode(original)
    let decoded = try DictionaryDecoder().decode(Floats.self, from: dict)
    #expect(decoded == original)
  }

  @Test("round-trips true bool")
  internal func boolTrue() throws {
    let original = BoolModel(flag: true)
    let dict: [String: Any] = try DictionaryEncoder().encode(original)
    let decoded = try DictionaryDecoder().decode(
      BoolModel.self, from: dict
    )
    #expect(decoded == original)
  }

  @Test("round-trips false bool")
  internal func boolFalse() throws {
    let original = BoolModel(flag: false)
    let dict: [String: Any] = try DictionaryEncoder().encode(original)
    let decoded = try DictionaryDecoder().decode(
      BoolModel.self, from: dict
    )
    #expect(decoded == original)
  }

  @Test("throws on integer overflow decoding as Int8")
  internal func integerOverflow() throws {
    let dict: [String: Any] = ["value": 200]
    #expect(throws: DecodingError.self) {
      _ = try DictionaryDecoder().decode(SmallInt.self, from: dict)
    }
  }
}
