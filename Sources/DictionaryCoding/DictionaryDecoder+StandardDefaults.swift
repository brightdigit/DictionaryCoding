//
//  DictionaryDecoder+StandardDefaults.swift
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

import Foundation

extension DictionaryDecoder {
  private static var standardDefaults: [String: Any] {
    [
      "Int": 0,
      "Int8": Int8(0),
      "Int16": Int16(0),
      "Int32": Int32(0),
      "Int64": Int64(0),
      "UInt": UInt(0),
      "UInt8": UInt8(0),
      "UInt16": UInt16(0),
      "UInt32": UInt32(0),
      "UInt64": UInt64(0),
      "Float": Float(0.0),
      "Double": 0.0,
      "String": "",
      "Bool": false,
      "Date": Date(timeIntervalSinceReferenceDate: 0),
      "Data": Data(),
    ]
  }

  internal var resolvedMissingValueStrategy: MissingValueDecodingStrategy {
    guard case .useStandardDefault = missingValueDecodingStrategy else {
      return missingValueDecodingStrategy
    }
    return .useDefault(defaults: Self.standardDefaults)
  }
}
