//
//  NSNumber+Bool.swift
//  AtLeast
//
//  Copyright (c) 2026 BrightDigit.
//  All rights reserved.
//

import Foundation

#if canImport(Darwin)
  import CoreFoundation
#endif

extension NSNumber {
  /// True if this NSNumber was created from a Swift/ObjC Bool, not an integer.
  ///
  /// Uses CFBooleanGetTypeID() on Darwin; objCType comparison on Linux.
  internal var isBool: Bool {
    #if canImport(Darwin)
      return CFGetTypeID(self) == CFBooleanGetTypeID()
    #else
      // swiftlint:disable:next line_length
      return String(cString: self.objCType) == String(cString: NSNumber(value: true).objCType)
    #endif
  }
}
