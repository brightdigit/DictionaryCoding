//
//  SuperDecoderChild.swift
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
