//
//  DictionaryDecoderOptions.swift
//  AtLeast
//
//  Copyright (c) 2026 BrightDigit.
//  All rights reserved.
//

import Foundation

/// Options set on the top-level decoder to pass down the decoding hierarchy.
internal struct DictionaryDecoderOptions {
  // MARK: - Instance Properties

  // swiftlint:disable:next line_length
  internal let missingValueDecodingStrategy: DictionaryDecoder.MissingValueDecodingStrategy
  internal let dateDecodingStrategy: DictionaryDecoder.DateDecodingStrategy
  internal let dataDecodingStrategy: DictionaryDecoder.DataDecodingStrategy
  internal let nonConformingFloatDecodingStrategy:
    DictionaryDecoder.NonConformingFloatDecodingStrategy
  internal let keyDecodingStrategy: DictionaryDecoder.KeyDecodingStrategy
  internal let userInfo: [CodingUserInfoKey: Any]
}
