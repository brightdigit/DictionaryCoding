//
//  DictionaryDecoderTests.swift
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

@Suite("DictionaryDecoder")
internal struct DictionaryDecoderTests {
  private struct Simple: Codable, Equatable {
    let name: String
    let count: Int
  }

  private struct WithOptional: Codable, Equatable {
    let value: String?
  }

  @Test("decodes string and int from dictionary")
  internal func decodesSimpleFields() throws {
    let dict: [String: Any] = ["name": "world", "count": 7]
    let result = try DictionaryDecoder().decode(Simple.self, from: dict)
    #expect(result.name == "world")
    #expect(result.count == 7)
  }

  @Test("decodes present optional")
  internal func decodesPresentOptional() throws {
    let dict: [String: Any] = ["value": "here"]
    let result = try DictionaryDecoder().decode(WithOptional.self, from: dict)
    #expect(result.value == "here")
  }

  @Test("decodes missing key as nil optional")
  internal func decodesMissingKeyAsNil() throws {
    let dict: [String: Any] = [:]
    let result = try DictionaryDecoder().decode(WithOptional.self, from: dict)
    #expect(result.value == nil)
  }

  @Test("throws on missing required key")
  internal func throwsOnMissingKey() {
    let dict: [String: Any] = ["name": "only"]
    #expect(throws: (any Error).self) {
      try DictionaryDecoder().decode(Simple.self, from: dict)
    }
  }
}
