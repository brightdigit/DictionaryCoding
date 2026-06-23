//
//  DictionaryCodingErrorTests.swift
//  AtLeast
//
//  Copyright (c) 2026 BrightDigit.
//  All rights reserved.
//

import DictionaryCoding
import Foundation
import Testing

@Suite("DictionaryCoding error paths")
internal struct DictionaryCodingErrorTests {
  // MARK: - Models

  private struct IntField: Codable { let value: Int }
  private struct StringField: Codable { let value: String }
  private struct NonOptionalString: Codable { let name: String }
  private struct WithArray: Codable { let items: [Int] }

  private struct AllOptional: Codable, Equatable {
    let name: String?
    let count: Int?
    let flag: Bool?
  }

  private struct Nested: Codable {
    let inner: InnerModel
  }

  private struct InnerModel: Codable {
    let count: Int
  }

  // MARK: - Type Mismatch

  @Test("throws decoding string where int expected")
  internal func typeMismatchStringForInt() {
    let dict: [String: Any] = ["value": "not-an-int"]
    #expect(throws: DecodingError.self) {
      try DictionaryDecoder().decode(IntField.self, from: dict)
    }
  }

  @Test("throws decoding number where string expected")
  internal func typeMismatchNumberForString() {
    let dict: [String: Any] = ["value": 42]
    #expect(throws: DecodingError.self) {
      try DictionaryDecoder().decode(StringField.self, from: dict)
    }
  }

  // MARK: - Null and Missing

  @Test("throws decoding NSNull for non-optional")
  internal func nullForNonOptional() {
    let dict: [String: Any] = ["name": NSNull()]
    #expect(throws: DecodingError.self) {
      try DictionaryDecoder().decode(
        NonOptionalString.self, from: dict
      )
    }
  }

  @Test("throws on missing required key")
  internal func missingRequiredKey() {
    let dict: [String: Any] = ["unrelated": "data"]
    #expect(throws: DecodingError.self) {
      try DictionaryDecoder().decode(IntField.self, from: dict)
    }
  }

  // MARK: - Nested Container Mismatches

  @Test("throws when nested keyed finds string not dict")
  internal func nestedKeyedTypeMismatch() {
    let dict: [String: Any] = ["inner": "not-a-dictionary"]
    #expect(throws: DecodingError.self) {
      try DictionaryDecoder().decode(Nested.self, from: dict)
    }
  }

  @Test("throws when nested unkeyed finds string not array")
  internal func nestedUnkeyedTypeMismatch() {
    let dict: [String: Any] = ["items": "not-an-array"]
    #expect(throws: DecodingError.self) {
      try DictionaryDecoder().decode(WithArray.self, from: dict)
    }
  }

  // MARK: - Empty Dictionary

  @Test("decodes empty dict as all-optional struct")
  internal func emptyDictionaryAllOptional() throws {
    let dict: [String: Any] = [:]
    let result = try DictionaryDecoder().decode(
      AllOptional.self, from: dict
    )
    #expect(
      result
        == AllOptional(
          name: nil, count: nil, flag: nil
        ))
  }

  // MARK: - NSDictionary Overload

  @Test("decodes from NSDictionary overload")
  internal func decodeFromNSDictionary() throws {
    let nsDict: NSDictionary = ["value": 99]
    let result = try DictionaryDecoder().decode(
      IntField.self, from: nsDict
    )
    #expect(result.value == 99)
  }

  @Test("NSDictionary overload throws on type mismatch")
  internal func nsDictionaryTypeMismatch() {
    let nsDict: NSDictionary = ["value": "not-an-int"]
    #expect(throws: DecodingError.self) {
      try DictionaryDecoder().decode(IntField.self, from: nsDict)
    }
  }
}
