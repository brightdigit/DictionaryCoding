//
//  DictionaryCodingRoundTripTests.swift
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

@Suite("DictionaryCoding round-trip")
internal struct DictionaryCodingRoundTripTests {
  private struct AllTypes: Codable, Equatable {
    let text: String
    let number: Int
    let decimal: Double
    let flag: Bool
    let optional: String?
  }

  private struct WithDate: Codable, Equatable {
    let timestamp: Date
  }

  @Test("round-trips struct with all primitive types")
  internal func roundTripsAllPrimitives() throws {
    let original = AllTypes(
      text: "abc", number: -5, decimal: 2.718, flag: false, optional: nil
    )
    let dict: [String: Any] = try DictionaryEncoder().encode(original)
    let decoded = try DictionaryDecoder().decode(AllTypes.self, from: dict)
    #expect(decoded == original)
  }

  @Test("round-trips struct with present optional")
  internal func roundTripsPresentOptional() throws {
    let original = AllTypes(text: "x", number: 0, decimal: 0, flag: true, optional: "set")
    let dict: [String: Any] = try DictionaryEncoder().encode(original)
    let decoded = try DictionaryDecoder().decode(AllTypes.self, from: dict)
    #expect(decoded == original)
  }

  @Test("round-trips Date via secondsSince1970 strategy")
  internal func roundTripsDate() throws {
    let date = Date(timeIntervalSince1970: 1_700_000_000)
    let original = WithDate(timestamp: date)
    let encoder = DictionaryEncoder()
    encoder.dateEncodingStrategy = .secondsSince1970
    let decoder = DictionaryDecoder()
    decoder.dateDecodingStrategy = .secondsSince1970
    let dict: [String: Any] = try encoder.encode(original)
    let decoded = try decoder.decode(WithDate.self, from: dict)
    #expect(decoded == original)
  }
}
