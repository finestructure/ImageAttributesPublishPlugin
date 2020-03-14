import Foundation
import HTMLString
import Ink
import Publish


enum Delimiter {
    case squareBrackets
    case parentheses

    var opening: Character {
        switch self {
            case .squareBrackets: return "["
            case .parentheses: return "("
        }
    }

    var closing: Character {
        switch self {
            case .squareBrackets: return "]"
            case .parentheses: return ")"
        }
    }
}

extension Substring {
    // Naive content delimination, in the sense that it does not
    // count multiple levels of opening delimiters.
    // Simply returns string between first occurrences of opening
    // and closing delimiters.
    func content(delimitedBy delimiter: Delimiter) -> Substring? {
        guard let delimPos = self.firstIndex(of: delimiter.opening) else { return nil }
        let start = self.index(after: delimPos)
        guard let end = self.firstIndex(of: delimiter.closing) else { return nil }
        guard start <= end else { return nil }
        return self[start..<end]
    }
}


struct Attribute {
    var key: String
    var value: String

    init(key: String, value: String) {
        self.key = key
        self.value = value
    }

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
            guard let title = markdown.content(delimitedBy: .squareBrackets) else { return html }
            guard let link = markdown.content(delimitedBy: .parentheses) else { return html }
            let parts = link.components(separatedBy: CharacterSet.whitespaces)

            guard let url = parts.first else { return html }

            guard parts.count > 1 else { return html }
            var attributes = parts
                .dropFirst()
                .compactMap(Attribute.init)
            if !title.isEmpty {
                attributes.append(Attribute(key: "alt", value: String(title).addingUnicodeEntities))
            }
            attributes.sort(by: { $0.key < $1.key })

            guard !attributes.isEmpty else { return html }
            let attrs = attributes
                .map({ $0.html})
                .joined(separator: " ")

            return #"<img src="\#(url)" \#(attrs)/>"#
        }
    }
}


