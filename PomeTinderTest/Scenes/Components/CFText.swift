//
//  CFText.swift
//  PomeTinderTest
//
//  Created by Le Quang Tuan Cuong(CuongLQT) on 10/10/2024.
//

import Foundation
import SwiftUI

func CFText<S: StringProtocol>(_ content: S?,
                               _ font: Font = .system(size: 15)) -> Text {
    Text(content ?? "")
        .apply(font)
}

func CFText<S: StringProtocol>(_ content: S,
                               _ font: Font = .system(size: 15)) -> Text {
    Text(content)
        .apply(font)
}

func CFText<S: StringProtocol>(_ content: S,
                               _ font: Font = .system(size: 15),
                               color: Color? = .black) -> Text {
    Text(content)
        .apply(font, color)
}

func CFText<S: StringProtocol>(_ content: S,
                               _ font: Font = .system(size: 15),
                               weight: Font.Weight? = nil) -> Text {
    Text(content)
        .apply(font, nil, weight)
}

func CFText<S: StringProtocol>(_ content: S,
                               _ font: Font = .system(size: 15),
                               color: Color? = .black,
                               weight: Font.Weight? = nil) -> Text {
    Text(content)
        .apply(font, color, weight)
}

// MARK: - Attribute Text
struct CFAttributesString: UIViewRepresentable {
    let attributeedString: NSMutableAttributedString
    
    init(attribute: NSMutableAttributedString) {
        self.attributeedString = attribute
    }
    
    func makeUIView(context: Context) -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.autoresizesSubviews = true
        label.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return label
    }
    func updateUIView(_ uiView: UILabel, context: Context) {
        uiView.attributedText = attributeedString
    }
}
