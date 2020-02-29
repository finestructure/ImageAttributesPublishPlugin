# ImageAttributes plugin for Publish

A [Publish](https://github.com/johnsundell/publish) plugin that allows you to specify image attributes. The following image markdown

```
![](https://example/image.png width=400)
```

is transformed into

```
<img src="https://example/image.png" width="400"/>
```

This is helpful for markdown editors like Ulysses that support image attributes like `width` and `height` to control rendering.

The `ImageAttributes` plugin is attribute agnostic, i.e. it will render any `foo=bar` pair into `foo="bar"` HTML markup, regardless of whether the attribute is an actual HTML attribute or not.

## Installation

To install it into your [Publish](https://github.com/johnsundell/publish) package, add it as a dependency within your `Package.swift` manifest:

```swift
let package = Package(
    ...
    dependencies: [
        ...
        .package(url: "https://github.com/finestructure/ImageAttributesPublishPlugin", from: "0.1.0")
    ],
    targets: [
        .target(
            ...
            dependencies: [
                ...
                "ImageAttributesPublishPlugin"
            ]
        )
    ]
    ...
)
```

Then import to use it:

```swift
import ImageAttributesPublishPlugin
```

For more information on how to use the Swift Package Manager, check out [this article](https://www.swiftbysundell.com/articles/managing-dependencies-using-the-swift-package-manager), or [its official documentation](https://github.com/apple/swift-package-manager/tree/master/Documentation).

## Usage

The plugin can then be used within any publishing pipeline like this:

```swift
import ImageAttributesPublishPlugin
...
try DeliciousRecipes().publish(using: [
    .installPlugin(.imageAttributes())
    ...
])
```