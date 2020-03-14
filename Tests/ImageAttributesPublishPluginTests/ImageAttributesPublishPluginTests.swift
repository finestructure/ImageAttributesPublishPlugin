@testable import ImageAttributesPublishPlugin
import Ink
import XCTest


final class ImageAttributesPublishPluginTests: XCTestCase {

    func test_content_delimitedBy() throws {
        XCTAssertEqual("foo [bar] baz".content(delimitedBy: .squareBrackets), "bar")
        XCTAssertEqual("foo ]bar] baz".content(delimitedBy: .squareBrackets), nil)
        XCTAssertEqual("foo ]bar[ baz".content(delimitedBy: .squareBrackets), nil)
        XCTAssertEqual("foo (bar) baz".content(delimitedBy: .parentheses), "bar")
        XCTAssertEqual("foo (bar[) baz".content(delimitedBy: .parentheses), "bar[")
        XCTAssertEqual("foo (b[ar]) baz".content(delimitedBy: .parentheses), "b[ar]")
        XCTAssertEqual("foo (".content(delimitedBy: .parentheses), nil)
        XCTAssertEqual("foo ()".content(delimitedBy: .parentheses), "")
        XCTAssertEqual("foo )".content(delimitedBy: .parentheses), nil)
    }

    func test_parse_single_attribute() throws {
        let parser = MarkdownParser(modifiers: [.imageAttributes()])
        let html = parser.html(from: "![](https://example/image.png width=400)")
        XCTAssertEqual(html, #"<img src="https://example/image.png" width="400"/>"#)
    }

    func test_parse_single_attribute_with_link_title() throws {
        let parser = MarkdownParser(modifiers: [.imageAttributes()])
        let html = parser.html(from: "![title](https://example/image.png width=400)")
        XCTAssertEqual(html, #"<img src="https://example/image.png" alt="title" width="400"/>"#)
    }

    func test_parse_single_attribute_with_link_title_with_spaces() throws {
        let parser = MarkdownParser(modifiers: [.imageAttributes()])
        let html = parser.html(from: "![title text](https://example/image.png width=400)")
        XCTAssertEqual(html, #"<img src="https://example/image.png" alt="title text" width="400"/>"#)
    }

    func test_parse_single_attribute_with_link_title_with_quotes() throws {
        let parser = MarkdownParser(modifiers: [.imageAttributes()])
        let html = parser.html(from: "![some \"title\" text](https://example/image.png width=400)")
        XCTAssertEqual(html, #"<img src="https://example/image.png" alt="some &#34;title&#34; text" width="400"/>"#)
    }

    func test_parse_generic_attributes() throws {
        let parser = MarkdownParser(modifiers: [.imageAttributes()])
        let html = parser.html(from: "![](https://example/image.png foo=1 bar=baz)")
        XCTAssertEqual(html, #"<img src="https://example/image.png" bar="baz" foo="1"/>"#)
    }

    func test_issue_2() throws {
        let  input = """
            ![An "Arena Gala" on iPad][image-1]

            [image-1]:    https://foo.com/image.png width=954
            """
        let parser = MarkdownParser(modifiers: [.imageAttributes()])
        let html = parser.html(from: input)
        XCTAssertEqual(html,
                       #"<img src="https://example/image.png" alt="An &#34;Arena Gala&#34; on iPad"  width="954"/>"#)
        //            #"<img src="https://foo.com/image.png width=954" alt="An "Arena Gala" on iPad"/>"#
    }

    static var allTests = [
        ("test_parse_single_attribute", test_parse_single_attribute),
    ]
}


extension String {
    // Test convenience so we can test with String rather than have to construct
    // substrings
    func content(delimitedBy delimiter: Delimiter) -> String? {
        (self[...] as Substring).content(delimitedBy: delimiter).map(String.init)
    }
}
