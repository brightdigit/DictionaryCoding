# ``DictionaryCoding``

Convert `Codable` values to and from `[String: Any]` dictionaries.

## Overview

DictionaryCoding provides ``DictionaryEncoder`` and ``DictionaryDecoder``, a pair of types that
mirror `JSONEncoder` / `JSONDecoder` but read and write plain in-memory dictionaries
(`[String: Any]` and `NSDictionary`) instead of serialized `Data`. This is useful for `plist`-shaped
payloads, WatchConnectivity / app-context dictionaries, `userInfo`, and any API that hands you a
`[String: Any]`.

```swift
struct Profile: Codable {
  let firstName: String
  let loginCount: Int
}

let dictionary = try DictionaryEncoder().encode(Profile(firstName: "Ada", loginCount: 42))
let profile = try DictionaryDecoder().decode(Profile.self, from: dictionary)
```

Both types expose configurable strategies for dates, binary data, non-conforming floating-point
values, and key naming (including snake-case conversion), plus a
``DictionaryDecoder/MissingValueDecodingStrategy`` for supplying defaults when keys are absent.

## Topics

### Encoding

- ``DictionaryEncoder``

### Decoding

- ``DictionaryDecoder``
