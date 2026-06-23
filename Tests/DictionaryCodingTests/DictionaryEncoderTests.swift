//
//  DictionaryEncoderTests.swift
//  AtLeast
//
//  Copyright (c) 2026 BrightDigit.
//  All rights reserved.
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
