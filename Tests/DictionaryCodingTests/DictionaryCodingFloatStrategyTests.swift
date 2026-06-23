//
//  DictionaryCodingFloatStrategyTests.swift
//  AtLeast
//
//  Copyright (c) 2026 BrightDigit.
//  All rights reserved.
//

import DictionaryCoding
import Foundation
import Testing

@Suite("DictionaryCoding non-conforming float strategies")
internal struct DictionaryCodingFloatStrategyTests {
  private struct FloatModel: Codable, Equatable {
    let value: Float
  }

  private struct DoubleModel: Codable, Equatable {
    let value: Double
  }

  // MARK: - convertToString strategy

  @Test("Float.infinity round-trips with convertToString")
  internal func floatInfinityConvertToString() throws {
    let encoder = DictionaryEncoder()
    encoder.nonConformingFloatEncodingStrategy = .convertToString(
      positiveInfinity: "Inf", negativeInfinity: "-Inf", nan: "NaN"
    )
    let decoder = DictionaryDecoder()
    decoder.nonConformingFloatDecodingStrategy = .convertFromString(
      positiveInfinity: "Inf", negativeInfinity: "-Inf", nan: "NaN"
    )

    for value: Float in [.infinity, -.infinity] {
      let dict: [String: Any] = try encoder.encode(
        FloatModel(value: value)
      )
      let decoded = try decoder.decode(FloatModel.self, from: dict)
      #expect(decoded.value == value)
    }

    let nanDict: [String: Any] = try encoder.encode(
      FloatModel(value: .nan)
    )
    let nanDecoded = try decoder.decode(
      FloatModel.self, from: nanDict
    )
    #expect(nanDecoded.value.isNaN)
  }

  @Test("Double.infinity round-trips with convertToString")
  internal func doubleInfinityConvertToString() throws {
    let encoder = DictionaryEncoder()
    encoder.nonConformingFloatEncodingStrategy = .convertToString(
      positiveInfinity: "+Inf", negativeInfinity: "-Inf", nan: "NaN"
    )
    let decoder = DictionaryDecoder()
    decoder.nonConformingFloatDecodingStrategy = .convertFromString(
      positiveInfinity: "+Inf", negativeInfinity: "-Inf", nan: "NaN"
    )

    for value: Double in [.infinity, -.infinity] {
      let dict: [String: Any] = try encoder.encode(
        DoubleModel(value: value)
      )
      let decoded = try decoder.decode(
        DoubleModel.self, from: dict
      )
      #expect(decoded.value == value)
    }

    let nanDict: [String: Any] = try encoder.encode(
      DoubleModel(value: .nan)
    )
    let nanDecoded = try decoder.decode(
      DoubleModel.self, from: nanDict
    )
    #expect(nanDecoded.value.isNaN)
  }

  // MARK: - .throw strategy

  @Test("throws encoding Float.infinity with .throw strategy")
  internal func floatInfinityThrows() throws {
    let encoder = DictionaryEncoder()
    encoder.nonConformingFloatEncodingStrategy = .throw

    #expect(throws: EncodingError.self) {
      let _: [String: Any] = try encoder.encode(
        FloatModel(value: .infinity)
      )
    }
  }

  @Test("throws encoding -Float.infinity with .throw strategy")
  internal func negativeFloatInfinityThrows() throws {
    let encoder = DictionaryEncoder()
    encoder.nonConformingFloatEncodingStrategy = .throw

    #expect(throws: EncodingError.self) {
      let _: [String: Any] = try encoder.encode(
        FloatModel(value: -.infinity)
      )
    }
  }

  @Test("throws encoding Float.nan with .throw strategy")
  internal func floatNanThrows() throws {
    let encoder = DictionaryEncoder()
    encoder.nonConformingFloatEncodingStrategy = .throw

    #expect(throws: EncodingError.self) {
      let _: [String: Any] = try encoder.encode(
        FloatModel(value: .nan)
      )
    }
  }

  @Test("throws encoding Double.infinity with .throw strategy")
  internal func doubleInfinityThrows() throws {
    let encoder = DictionaryEncoder()
    encoder.nonConformingFloatEncodingStrategy = .throw

    #expect(throws: EncodingError.self) {
      let _: [String: Any] = try encoder.encode(
        DoubleModel(value: .infinity)
      )
    }
  }
}
