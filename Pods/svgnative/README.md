# svgnative + Xcode

[![CI Status](http://img.shields.io/travis/SDWebImage/svgnative-Xcode.svg?style=flat)](https://travis-ci.org/SDWebImage/svgnative-Xcode)
[![Version](https://img.shields.io/cocoapods/v/svgnative.svg?style=flat)](http://cocoapods.org/pods/svgnative)
[![License](https://img.shields.io/cocoapods/l/svgnative.svg?style=flat)](http://cocoapods.org/pods/svgnative)
[![Platform](https://img.shields.io/cocoapods/p/svgnative.svg?style=flat)](http://cocoapods.org/pods/svgnative)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/SDWebImage/svgnative-Xcode)
[![SwiftPM compatible](https://img.shields.io/badge/SwiftPM-compatible-brightgreen.svg)](https://swift.org/package-manager/)

A wrapper for [svg-native](https://github.com/adobe/svg-native-viewer) + Xcode project.
This enables Carthage && SwiftPM support.

This repo also including the CocoaPods's spec file to use svg-native.

## Requirements

+ iOS 9
+ macOS 10.10
+ tvOS 9.0
+ watchOS 2.0

## Note

The 0.1.0-beta version use the custom SHA, because the upstream does not have tagged version.

## Installation

### Carthage

svgnative is (via this repo) available through [Carthage](https://github.com/Carthage/Carthage).

```
github "SDWebImage/svgnative-Xcode"
```

### CocoaPods

svgnative is available through [CocoaPods](https://github.com/CocoaPods/CocoaPods).

```
pod 'svgnative'
```

### SwiftPM

svgnative is available through [Swift Package Manager](https://img.shields.io/badge/SwiftPM-compatible-brightgreen.svg).

```swift
let package = Package(
    dependencies: [
        .package(url: "https://github.com/SDWebImage/svgnative-Xcode", from: "0.2.0")
    ],
    // ...
)
```

## Usage

Use svgnative as you would normally, this is just a repo that adds an Xcode proj.

+ Objective-C++

```objective-c
#import <svgnative/SVGRenderer.h>
```

Note C++ module is C++20 standard and disabled for clang by default currently. Use header include instead.

+ Swift

```swift
import svgnative
```

## For C wrapper

Use the `svgnative/SVGNativeCWrapper.h` instead of C++ headers.

## License

svgnative is available under the [Apache License 2.0](https://github.com/adobe/svg-native-viewer/blob/main/LICENSE).


