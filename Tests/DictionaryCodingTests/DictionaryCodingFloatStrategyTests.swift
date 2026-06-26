//
//  DictionaryCodingFloatStrategyTests.swift
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
