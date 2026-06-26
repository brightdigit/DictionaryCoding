//
//  DictionaryDecoder.KeyDecodingStrategy.swift
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

extension DictionaryDecoder.KeyDecodingStrategy {
  internal static func convertFromSnakeCase(_ stringKey: String) -> String {
    guard !stringKey.isEmpty else {
      return stringKey
    }

    // Find the first non-underscore character
    guard let firstNonUnderscore = stringKey.firstIndex(where: { $0 != "_" }) else {
      // Reached the end without finding an _
      return stringKey
    }

    // Find the last non-underscore character
    var lastNonUnderscore = stringKey.index(before: stringKey.endIndex)
    while lastNonUnderscore > firstNonUnderscore
      && stringKey[lastNonUnderscore] == "_"
    {
      stringKey.formIndex(before: &lastNonUnderscore)
    }

    let keyRange = firstNonUnderscore...lastNonUnderscore
    let leadingUnderscoreRange = stringKey.startIndex..<firstNonUnderscore
    let trailingUnderscoreRange =
      stringKey.index(after: lastNonUnderscore)..<stringKey.endIndex

    let components = stringKey[keyRange].split(separator: "_")
    let joinedString: String
    if components.count == 1 {
      // No underscores in key, leave the word as is - maybe already camel cased
      joinedString = String(stringKey[keyRange])
    } else {
      joinedString =
        ([components[0].lowercased()] + components[1...].map { $0.capitalized })
        .joined()
    }

    return buildResult(
      joined: joinedString,
      leading: leadingUnderscoreRange,
      trailing: trailingUnderscoreRange,
      in: stringKey
    )
  }

  private static func buildResult(
    joined: String,
    leading: Range<String.Index>,
    trailing: Range<String.Index>,
    in stringKey: String
  ) -> String {
    if leading.isEmpty && trailing.isEmpty {
      return joined
    } else if !leading.isEmpty && !trailing.isEmpty {
      return String(stringKey[leading]) + joined + String(stringKey[trailing])
    } else if !leading.isEmpty {
      return String(stringKey[leading]) + joined
    } else {
      return joined + String(stringKey[trailing])
    }
  }
}
