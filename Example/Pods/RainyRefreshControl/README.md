# RainyRefreshControl

[![Swift 3.0](https://img.shields.io/badge/Swift-3.0-orange.svg?style=flat)](https://developer.apple.com/swift/)
[![Platforms iOS](https://img.shields.io/badge/Platforms-iOS-lightgray.svg?style=flat)](https://developer.apple.com/swift/)
[![Xcode 8.0+](https://img.shields.io/badge/Xcode-8.0+-blue.svg?style=flat)](https://developer.apple.com/swift/)

Simple refresh control for iOS based on [POP](https://github.com/facebook/pop), SpriteKit and Core Graphics.

Project inspired by [concept](https://dribbble.com/shots/2242263--1-Pull-to-refresh-Freebie-Weather-Concept) of [Yup Nguyen](https://dribbble.com/yupnguyen)

![capture_umbrella_refresh](gif/umbrella_refresh.gif "capture_umbrella_refresh")

## Installation

## Installation with CocoaPods

To integrate RainyRefreshControl into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '9.0'

target 'TargetName' do
pod 'RainyRefreshControl'
end
```

Then, run the following command:

```bash
$ pod install
```

## Usage

Just import RainyRefreshControl framework into your class and add it to UITableView or UICollectionView:

```swift
let refresh = RainyRefreshControl()
refresh.addTarget(self, action: #selector(ViewController.doRefresh), for: .valueChanged)
tableView.addSubview(refresh)

```

## License

RainyRefreshControl is released under the MIT license. See [LICENSE](LICENSE) for details.
