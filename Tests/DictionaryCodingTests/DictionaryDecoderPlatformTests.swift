//
//  DictionaryDecoderPlatformTests.swift
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

@Suite("DictionaryDecoder platform behaviour")
internal struct DictionaryDecoderPlatformTests {
  #if canImport(Darwin)
    internal static let isDarwin = true
  #else
    internal static let isDarwin = false
  #endif

  // NSNumber wrapping Bool must decode as Bool, not as Int.
  @Test("NSNumber bool decoded as Bool")
  internal func nsnumberBoolDecodedAsBool() throws {
    struct BoolFixture: Codable {
      let flag: Bool
    }
    let dict: [String: Any] = ["flag": NSNumber(value: true)]
    let result = try DictionaryDecoder().decode(BoolFixture.self, from: dict)
    #expect(result.flag == true)
  }

  // NSNumber wrapping Bool must be rejected when Int is expected.
  // On Linux, Bool and Int8 share objCType "c" so isBool is unreliable;
  // boolean rejection only works on Darwin (CFBooleanGetTypeID).
  @Test("NSNumber bool rejected for Int")
  internal func nsnumberBoolRejectedForInt() {
    struct IntFixture: Codable {
      let count: Int
    }
    let dict: [String: Any] = ["count": NSNumber(value: true)]
    withKnownIssue(
      "Bool/Int8 share objCType on Linux"
    ) {
      #expect(throws: (any Error).self) {
        try DictionaryDecoder().decode(IntFixture.self, from: dict)
      }
    } when: {
      !Self.isDarwin
    }
  }

  // NSNumber wrapping Bool must be rejected when Double is expected.
  @Test("NSNumber bool rejected for Double")
  internal func nsnumberBoolRejectedForDouble() {
    struct DoubleFixture: Codable {
      let value: Double
    }
    let dict: [String: Any] = ["value": NSNumber(value: true)]
    #expect(throws: (any Error).self) {
      try DictionaryDecoder().decode(DoubleFixture.self, from: dict)
    }
  }

  // Darwin-only: CFUUID values should decode as UUID.
  // The trait disables the test on Linux; #if canImport(Darwin) in the body
  // prevents CF types from being compiled on non-Darwin platforms.
  @Test("CFUUID value decoded as UUID", .enabled(if: isDarwin))
  internal func cfuuidDecodedAsUUID() throws {
    #if canImport(Darwin)
      struct UUIDFixture: Codable {
        let id: UUID
      }
      guard let cfuuid = CFUUIDCreate(kCFAllocatorDefault) else {
        Issue.record("CFUUIDCreate returned nil")
        return
      }
      let dict: [String: Any] = ["id": cfuuid as AnyObject]
      let result = try DictionaryDecoder().decode(UUIDFixture.self, from: dict)
      let cfStringRef = CFUUIDCreateString(kCFAllocatorDefault, cfuuid)
      guard let cfString = cfStringRef as String? else {
        Issue.record("CFUUIDCreateString returned nil")
        return
      }
      #expect(result.id == UUID(uuidString: cfString))
    #else
      Issue.record("CFUUID test must not run on non-Darwin platforms")
    #endif
  }
}
