//
//  DictionaryCodingSuperDecoderTests.swift
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

@Suite("DictionaryCoding superDecoder and key strategies")
internal struct DictionaryCodingSuperDecoderTests {
  private struct PrefixModel: Codable, Equatable {
    let name: String
    let age: Int
  }

  // MARK: - SuperDecoder Tests

  @Test("round-trips class hierarchy using superDecoder")
  internal func superDecoderRoundTrip() throws {
    let original = SuperDecoderChild(
      baseValue: 10, childValue: "hello"
    )
    let dict: [String: Any] = try DictionaryEncoder().encode(original)
    let decoded = try DictionaryDecoder().decode(
      SuperDecoderChild.self, from: dict
    )
    #expect(decoded.baseValue == 10)
    #expect(decoded.childValue == "hello")
  }

  @Test("superDecoder from manual dictionary")
  internal func superDecoderFromManualDict() throws {
    let dict: [String: Any] = [
      "childValue": "world",
      "super": ["baseValue": 42] as [String: Any],
    ]
    let decoded = try DictionaryDecoder().decode(
      SuperDecoderChild.self, from: dict
    )
    #expect(decoded.baseValue == 42)
    #expect(decoded.childValue == "world")
  }

  // MARK: - Custom Key Strategies

  @Test("custom key encoding applies prefix")
  internal func customKeyEncoding() throws {
    let encoder = DictionaryEncoder()
    encoder.keyEncodingStrategy = .custom { path in
      let key = path[path.count - 1].stringValue
      return DictionaryCodingTestKey(
        stringValue: "pfx_\(key)"
      )
    }
    let value = PrefixModel(name: "Test", age: 25)
    let dict: [String: Any] = try encoder.encode(value)
    #expect(dict["pfx_name"] as? String == "Test")
    #expect(dict["pfx_age"] as? Int == 25)
  }

  @Test("custom key decoding strips prefix")
  internal func customKeyDecoding() throws {
    let dict: [String: Any] = [
      "pfx_name": "Test", "pfx_age": 25,
    ]
    let decoder = DictionaryDecoder()
    decoder.keyDecodingStrategy = .custom { path in
      let key = path[path.count - 1].stringValue
      let stripped = key.replacingOccurrences(
        of: "pfx_", with: ""
      )
      return DictionaryCodingTestKey(stringValue: stripped)
    }
    let result = try decoder.decode(PrefixModel.self, from: dict)
    #expect(result.name == "Test")
    #expect(result.age == 25)
  }
}
