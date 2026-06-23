//
//  SuperDecoderBase.swift
//  AtLeast
//
//  Copyright (c) 2026 BrightDigit.
//  All rights reserved.
//

import Foundation

internal class SuperDecoderBase: Codable {
  internal let baseValue: Int

  internal init(baseValue: Int) {
    self.baseValue = baseValue
  }
}
