//
//  DictionaryDecoder.KeyDecodingStrategy.swift
//  AtLeast
//
//  Copyright (c) 2026 BrightDigit.
//  All rights reserved.
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
