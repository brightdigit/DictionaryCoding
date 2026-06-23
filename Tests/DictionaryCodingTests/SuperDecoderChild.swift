//
//  SuperDecoderChild.swift
//  AtLeast
//
//  Copyright (c) 2026 BrightDigit.
//  All rights reserved.
//

import DictionaryCoding
import Foundation

internal class SuperDecoderChild: SuperDecoderBase {
  private enum CodingKeys: String, CodingKey {
    case childValue
  }

  internal let childValue: String

  internal init(baseValue: Int, childValue: String) {
    self.childValue = childValue
    super.init(baseValue: baseValue)
  }

  internal required init(from decoder: Decoder) throws {
    let container = try decoder.container(
      keyedBy: CodingKeys.self
    )
    self.childValue = try container.decode(
      String.self, forKey: .childValue
    )
    try super.init(from: container.superDecoder())
  }

  override internal func encode(to encoder: Encoder) throws {
    var container = encoder.container(
      keyedBy: CodingKeys.self
    )
    try container.encode(childValue, forKey: .childValue)
    try super.encode(to: container.superEncoder())
  }
}
