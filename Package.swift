// swift-tools-version: 6.3
//
//  Package.swift
//  DictionaryCoding
//
//  Copyright (c) 2026 BrightDigit.
//  All rights reserved.
//

import PackageDescription

// swiftlint:disable:next explicit_acl explicit_top_level_acl
let package = Package(
  name: "DictionaryCoding",
  platforms: [
    .macOS(.v15),
    .iOS(.v26),
    .tvOS(.v26),
    .watchOS(.v26),
    .visionOS(.v26)
  ],
  products: [
    .library(
      name: "DictionaryCoding",
      targets: ["DictionaryCoding"]
    ),
  ],
  targets: [
    .target(
      name: "DictionaryCoding",
      swiftSettings: [.swiftLanguageMode(.v6)]
    ),
    .testTarget(
      name: "DictionaryCodingTests",
      dependencies: ["DictionaryCoding"]
    ),
  ]
)
