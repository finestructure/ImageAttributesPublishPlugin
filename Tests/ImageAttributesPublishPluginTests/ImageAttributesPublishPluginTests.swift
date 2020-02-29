import ImageAttributesPublishPlugin
import Ink
import XCTest

final class ImageAttributesPublishPluginTests: XCTestCase {

    func test_parse_single_attribute() throws {
        let parser = MarkdownParser(modifiers: [.imageAttributes()])
        let html = parser.html(from: "![](https://example/image.png width=400)")
        XCTAssertEqual(html, #"<img src="https://example/image.png" width="400"/>"#)
    }

    static var allTests = [
        ("test_parse_single_attribute", test_parse_single_attribute),
    ]
}
