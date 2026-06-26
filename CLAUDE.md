# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this
repository.

## Overview

**DictionaryCoding** is a single-target Swift package providing `DictionaryEncoder` and
`DictionaryDecoder` — a `Codable`-based `Encoder`/`Decoder` pair that converts `Codable` values to
and from `[String: Any]` and `NSDictionary`, mirroring the `JSONEncoder` / `JSONDecoder` API. It has
**no external dependencies**.

The public entry points are ``DictionaryEncoder`` (`Sources/DictionaryCoding/DictionaryEncoder.swift`,
`+Encode.swift`) and ``DictionaryDecoder`` (`DictionaryDecoder.swift`). Everything else
(`*Impl*`, `*Container*`, `*Storage*`, `DictionaryCodingKey`, the `EncodingError`/`DecodingError`
extensions, `NSNumber+Bool`) is internal plumbing that backs the two `open` classes.

## Architecture

- **One file per type.** SwiftLint's `one_declaration_per_file` and `file_name` rules are enabled;
  keep filenames matching their primary type, and use the `Type+Feature.swift` convention for
  extensions (e.g. `DictionaryDecoderImpl+UnboxIntegers.swift`).
- **Strategies are nested enums** on the encoder/decoder (date, data, non-conforming float, key,
  and `MissingValueDecodingStrategy`). Mirror `Foundation`'s `JSONEncoder`/`JSONDecoder` semantics
  when adding or changing a strategy.
- **`Combine` conformances are guarded** by `#if canImport(Combine)` (`TopLevelEncoder` /
  `TopLevelDecoder`). Keep new Combine surface behind that check so non-Apple builds stay clean.

## Build, Test & Lint

```bash
make build          # swift build
make test           # swift test --enable-code-coverage
make lint           # strict swift-format + swiftlint + periphery (via mise)
make format         # format only, no linting
make docs-build     # build DocC for the DictionaryCoding target
```

Tooling is pinned in `.mise.toml` (swift-format, swiftlint, periphery, xcodegen); `make lint`
shells out through `Scripts/lint.sh`, which bootstraps those via `mise`. `Scripts/header.sh`
stamps the standard BrightDigit license header onto every file in `Sources/`.

> **Toolchain:** `Package.swift` declares `swift-tools-version: 6.3` and platforms macOS 15 /
> iOS·tvOS·watchOS·visionOS 26. Building requires the Swift 6.3 toolchain (Xcode 26+); older
> toolchains cannot parse the manifest. The package builds in Swift 6 language mode
> (`swiftLanguageMode(.v6)`).

## Code Style

- 2-space indentation, 100-column target (`.swift-format`); SwiftLint adds opt-in rules and tighter
  limits (`file_length` warn 225 / error 300, `function_body_length` warn 50 / error 76).
- Explicit access control is required (`explicit_acl` / `explicit_top_level_acl`); the package
  manifest is the one place that opts out, via a `swiftlint:disable` comment.
- All public declarations must carry documentation comments (`AllPublicDeclarationsHaveDocumentation`,
  `missing_docs`).
