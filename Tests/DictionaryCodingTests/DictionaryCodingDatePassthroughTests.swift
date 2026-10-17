//
//  DictionaryCodingDatePassthroughTests.swift
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

@Suite("DictionaryCoding date passthrough strategy")
internal struct DictionaryCodingDatePassthroughTests {
  private struct WithDate: Codable, Equatable {
    let timestamp: Date
  }

  private struct Reading: Codable, Equatable {
    let timestamp: Date
    let watts: Int
  }

  private struct Ride: Codable, Equatable {
    let startedAt: Date
    let readings: [Reading]
    let laps: [Date]
  }

  /// A date whose fractional second loses its lowest bit in a round trip through
  /// `timeIntervalSince1970`, so the exact-value checks catch an epoch conversion.
  private static let date = Date(timeIntervalSinceReferenceDate: 800_000_000.1)

  private static func makeEncoder() -> DictionaryEncoder {
    let encoder = DictionaryEncoder()
    encoder.dateEncodingStrategy = .passthrough
    return encoder
  }

  private static func makeDecoder() -> DictionaryDecoder {
    let decoder = DictionaryDecoder()
    decoder.dateDecodingStrategy = .passthrough
    return decoder
  }

  private static func makeRide() -> Ride {
    let readings = (0..<3).map { second in
      Reading(timestamp: date.addingTimeInterval(Double(second)), watts: 200 + second)
    }
    return Ride(
      startedAt: date,
      readings: readings,
      laps: [date, date.addingTimeInterval(600)]
    )
  }

  // MARK: - Encoding

  @Test("passthrough stores the Date itself rather than a number")
  internal func passthroughStoresDate() throws {
    let dict: [String: Any] = try Self.makeEncoder().encode(WithDate(timestamp: Self.date))
    #expect(!(dict["timestamp"] is NSNumber))
    let stored = try #require(dict["timestamp"] as? Date)
    #expect(stored == Self.date)
  }

  @Test("passthrough stores Dates inside nested containers and arrays")
  internal func passthroughStoresNestedDates() throws {
    let ride = Self.makeRide()
    let dict: [String: Any] = try Self.makeEncoder().encode(ride)
    let readings = try #require(dict["readings"] as? [[String: Any]])
    let timestamps = readings.compactMap { $0["timestamp"] as? Date }
    #expect(timestamps == ride.readings.map(\.timestamp))
    let laps = try #require(dict["laps"] as? [Date])
    #expect(laps == ride.laps)
  }

  // MARK: - Decoding

  @Test("passthrough round-trips exactly, including fractional seconds")
  internal func passthroughRoundTrip() throws {
    let ride = Self.makeRide()
    let dict: [String: Any] = try Self.makeEncoder().encode(ride)
    let decoded = try Self.makeDecoder().decode(Ride.self, from: dict)
    #expect(decoded == ride)
  }

  @Test("passthrough round-trips the reference date given as negative zero")
  internal func passthroughRoundTripNegativeZero() throws {
    let original = WithDate(timestamp: Date(timeIntervalSinceReferenceDate: -0.0))
    let dict: [String: Any] = try Self.makeEncoder().encode(original)
    let decoded = try Self.makeDecoder().decode(WithDate.self, from: dict)
    #expect(decoded == original)
  }

  @Test("passthrough decodes Date and NSDate values already in a dictionary")
  internal func passthroughDecodesNativeDates() throws {
    let decoder = Self.makeDecoder()
    let swiftDate: [String: Any] = ["timestamp": Self.date]
    let nsDate: [String: Any] = [
      "timestamp": NSDate(timeIntervalSinceReferenceDate: Self.date.timeIntervalSinceReferenceDate)
    ]
    #expect(try decoder.decode(WithDate.self, from: swiftDate).timestamp == Self.date)
    #expect(try decoder.decode(WithDate.self, from: nsDate).timestamp == Self.date)
  }

  @Test("passthrough throws a type mismatch when the value is not a Date")
  internal func passthroughRejectsNumber() throws {
    let dict: [String: Any] = ["timestamp": 1_700_000_000.0]
    let error = try #require(throws: DecodingError.self) {
      try Self.makeDecoder().decode(WithDate.self, from: dict)
    }
    guard case .typeMismatch(let type, let context) = error else {
      Issue.record("Expected a type mismatch, got \(error)")
      return
    }
    #expect(type is Date.Type)
    #expect(context.codingPath.map(\.stringValue) == ["timestamp"])
  }

  #if canImport(Darwin)
    @Test("passthrough output is a valid property list")
    internal func passthroughOutputIsPropertyList() throws {
      let ride = Self.makeRide()
      let dict: [String: Any] = try Self.makeEncoder().encode(ride)
      let data = try PropertyListSerialization.data(
        fromPropertyList: dict, format: .binary, options: 0
      )
      let restored = try PropertyListSerialization.propertyList(from: data, format: nil)
      let restoredDict = try #require(restored as? [String: Any])
      let decoded = try Self.makeDecoder().decode(Ride.self, from: restoredDict)
      #expect(decoded == ride)
    }
  #endif
}
