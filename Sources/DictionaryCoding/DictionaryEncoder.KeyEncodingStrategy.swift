//
//  DictionaryEncoder.KeyEncodingStrategy.swift
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

extension DictionaryEncoder.KeyEncodingStrategy {
  internal static func convertToSnakeCase(_ stringKey: String) -> String {
    guard !stringKey.isEmpty else {
      return stringKey
    }

    var words: [Range<String.Index>] = []
    var wordStart = stringKey.startIndex
    var searchRange = stringKey.index(after: wordStart)..<stringKey.endIndex

    while let upperCaseRange = stringKey.rangeOfCharacter(
      from: CharacterSet.uppercaseLetters,
      options: [],
      range: searchRange
    ) {
      words.append(wordStart..<upperCaseRange.lowerBound)
      searchRange = upperCaseRange.lowerBound..<searchRange.upperBound
      updateWordBoundary(
        stringKey: stringKey,
        upperCaseRange: upperCaseRange,
        searchRange: &searchRange,
        wordStart: &wordStart,
        words: &words
      )
    }
    words.append(wordStart..<searchRange.upperBound)
    return words.map { stringKey[$0].lowercased() }.joined(separator: "_")
  }

  private static func updateWordBoundary(
    stringKey: String,
    upperCaseRange: Range<String.Index>,
    searchRange: inout Range<String.Index>,
    wordStart: inout String.Index,
    words: inout [Range<String.Index>]
  ) {
    guard
      let lowerCaseRange = stringKey.rangeOfCharacter(
        from: CharacterSet.lowercaseLetters,
        options: [],
        range: searchRange
      )
    else {
      wordStart = searchRange.lowerBound
      searchRange = searchRange.upperBound..<searchRange.upperBound
      return
    }

    let nextAfterCapital = stringKey.index(after: upperCaseRange.lowerBound)
    if lowerCaseRange.lowerBound == nextAfterCapital {
      wordStart = upperCaseRange.lowerBound
    } else {
      let beforeLower = stringKey.index(before: lowerCaseRange.lowerBound)
      words.append(upperCaseRange.lowerBound..<beforeLower)
      wordStart = beforeLower
    }
    searchRange = lowerCaseRange.upperBound..<searchRange.upperBound
  }
}
