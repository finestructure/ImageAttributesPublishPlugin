import Foundation
import Ink
import Publish


struct Attribute {
    var key: String
    var value: String

    init?(_ rawValue: String) {
        let pair = rawValue.split(separator: "=").map(String.init)
        guard pair.count == 2 else { return nil }
        key = pair[0]
        value = pair[1]
    }

    var html: String {
        "\(key)=\"\(value)\""
    }
}


public extension Plugin {
    static func imageAttributes() -> Self {
        Plugin(name: "ImageAttributes") { context in
            context.markdownParser.addModifier(.imageAttributes())
        }
    }
}


public extension Modifier {
    static func imageAttributes() -> Self {
        return Modifier(target: .images) { html, markdown in
            guard
                let paren = markdown.firstIndex(of: "("),
                markdown.last == ")" else { return html }

            let start = markdown.index(after: paren)
            let link = markdown[start...].dropLast()
            let parts = link.components(separatedBy: CharacterSet.whitespaces)

            guard let url = parts.first else { return html }

            guard parts.count > 1 else { return html }
            let attributes = parts
                .dropFirst()
                .compactMap(Attribute.init)

            guard !attributes.isEmpty else { return html }
            let attrs = attributes
                .map({ $0.html})
                .joined(separator: " ")

            return #"<img src="\#(url)" \#(attrs)/>"#
        }
    }
}


