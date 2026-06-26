//
//  DictionaryEncoderTests.swift
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

@Suite("DictionaryEncoder")
internal struct DictionaryEncoderTests {
  private struct Simple: Codable, Equatable {
    let name: String
    let count: Int
    let ratio: Double
    let flag: Bool
  }

  private struct WithOptional: Codable, Equatable {
    let value: String?
  }

  private struct Nested: Codable, Equatable {
    let label: String
    let inner: Simple
  }

  @Test("encodes string, int, double, bool fields as top-level keys")
  internal func encodesSimpleFields() throws {
    let value = Simple(name: "hello", count: 42, ratio: 3.14, flag: true)
    let dict: [String: Any] = try DictionaryEncoder().encode(value)
    #expect(dict["name"] as? String == "hello")
    #expect(dict["count"] as? Int == 42)
    #expect(dict["flag"] as? Bool == true)
    let ratio = try #require(dict["ratio"] as? Double)
    #expect(abs(ratio - 3.14) < 0.001)
  }

  @Test("encodes present optional as value")
  internal func encodesPresentOptional() throws {
    let value = WithOptional(value: "present")
    let dict: [String: Any] = try DictionaryEncoder().encode(value)
    #expect(dict["value"] as? String == "present")
  }

  @Test("encodes nil optional as absent key")
  internal func encodesNilOptional() throws {
    let value = WithOptional(value: nil)
    let dict: [String: Any] = try DictionaryEncoder().encode(value)
    #expect(dict["value"] == nil)
  }

  @Test("encodes nested struct as sub-dictionary")
  internal func encodesNestedStruct() throws {
    let inner = Simple(name: "inner", count: 1, ratio: 0.5, flag: false)
    let value = Nested(label: "outer", inner: inner)
    let dict: [String: Any] = try DictionaryEncoder().encode(value)
    #expect(dict["label"] as? String == "outer")
    let innerDict = try #require(dict["inner"] as? [String: Any])
    #expect(innerDict["name"] as? String == "inner")
  }
}
