//
//  ExpandableText.swift
//  TVMaze
//
//  Created by Juan david Lopera lopez on 22/04/25.
//

import SwiftUI

struct ExpandableText: View {
    // MARK: - Private Properties
    private let text: String
    private let lineLimit: Int
    
    @State private var isExpanded: Bool = false
    
    // MARK: - Internal Init
    init(text: String, lineLimit: Int) {
        self.text = text
        self.lineLimit = lineLimit
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(text)
                .lineLimit(isExpanded ? nil : lineLimit)
                .truncationMode(.tail)
            Button(isExpanded ? "Show less" : "Show more") {
                isExpanded.toggle()
            }
            .font(.caption)
            .foregroundColor(.blue)
        }
    }
}

#Preview {
    ExpandableText(text: "Some test just for testing propurse\nSome test just for testing propurse", lineLimit: 3)
}
