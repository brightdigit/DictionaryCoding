//
//  DictionaryEncoderOptions.swift
//  AtLeast
//
//  Copyright (c) 2026 BrightDigit.
//  All rights reserved.
//

import Foundation

/// Options set on the top-level encoder to pass down the encoding hierarchy.
internal struct DictionaryEncoderOptions {
  // MARK: - Instance Properties

  internal let dateEncodingStrategy: DictionaryEncoder.DateEncodingStrategy
  internal let dataEncodingStrategy: DictionaryEncoder.DataEncodingStrategy
  internal let nonConformingFloatEncodingStrategy:
    DictionaryEncoder.NonConformingFloatEncodingStrategy
  internal let keyEncodingStrategy: DictionaryEncoder.KeyEncodingStrategy
  internal let userInfo: [CodingUserInfoKey: Any]
}
