<p align="center">
  <h1 align="center">DictionaryCoding</h1>
</p>

<p align="center">
  <a href="https://swiftpackageindex.com/brightdigit/DictionaryCoding">
    <img src="https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fbrightdigit%2FDictionaryCoding%2Fbadge%3Ftype%3Dswift-versions" alt="Swift Versions" />
  </a>
  <a href="https://swiftpackageindex.com/brightdigit/DictionaryCoding">
    <img src="https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fbrightdigit%2FDictionaryCoding%2Fbadge%3Ftype%3Dplatforms" alt="Platforms" />
  </a>
  <a href="https://github.com/brightdigit/DictionaryCoding/blob/main/LICENSE">
    <img src="https://img.shields.io/github/license/brightdigit/DictionaryCoding" alt="License" />
  </a>
</p>

A `Codable`-based `Encoder` and `Decoder` that convert `Codable` values to and from
`[String: Any]` (and `NSDictionary`) — the dictionary equivalent of `JSONEncoder` /
`JSONDecoder`. Use it when you need a plain in-memory dictionary instead of serialized data:
`plist`-shaped payloads, WatchConnectivity / app-context dictionaries, `userInfo`, and any API
that hands you a `[String: Any]`.

## Features

- `DictionaryEncoder` / `DictionaryDecoder` with a `JSONEncoder`-style API.
- Configurable strategies for dates, data, non-conforming floats, and keys
  (including `.convertToSnakeCase` / `.convertFromSnakeCase`).
- A `MissingValueDecodingStrategy` for filling in defaults when keys are absent.
- `Combine.TopLevelEncoder` / `TopLevelDecoder` conformance where Combine is available.

## Usage

```swift
import DictionaryCoding

struct Profile: Codable {
  let firstName: String
  let loginCount: Int
}

// Encode to a dictionary
let profile = Profile(firstName: "Ada", loginCount: 42)
let dictionary: [String: Any] = try DictionaryEncoder().encode(profile)
// ["firstName": "Ada", "loginCount": 42]

// Decode from a dictionary
let decoded = try DictionaryDecoder().decode(Profile.self, from: dictionary)
```

### Strategies

```swift
let encoder = DictionaryEncoder()
encoder.keyEncodingStrategy = .convertToSnakeCase
encoder.dateEncodingStrategy = .secondsSince1970

let decoder = DictionaryDecoder()
decoder.keyDecodingStrategy = .convertFromSnakeCase
decoder.missingValueDecodingStrategy = .useStandardDefault   // fall back to type defaults
```

## Requirements

- Swift 6.3+ / Xcode 26+
- macOS 15+, iOS 26+, tvOS 26+, watchOS 26+, visionOS 26+

## Installation

Add DictionaryCoding to your `Package.swift` dependencies:

```swift
dependencies: [
  .package(url: "https://github.com/brightdigit/DictionaryCoding.git", from: "1.0.0")
]
```

Then add it to your target:

```swift
.target(
  name: "YourTarget",
  dependencies: [
    .product(name: "DictionaryCoding", package: "DictionaryCoding")
  ]
)
```

## License

DictionaryCoding is available under the MIT license. See the [LICENSE](LICENSE) file for more info.
