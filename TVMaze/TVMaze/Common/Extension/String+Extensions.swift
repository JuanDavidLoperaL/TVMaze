//
//  String+Extensions.swift
//  TVMaze
//
//  Created by Juan david Lopera lopez on 22/04/25.
//

import Foundation

extension String {
    var htmlStripped: String {
        let regex = try! NSRegularExpression(pattern: "<[^>]+>", options: [])
        let range = NSRange(location: 0, length: self.count)
        let cleanString = regex.stringByReplacingMatches(in: self, options: [], range: range, withTemplate: "")
        return cleanString
    }
}
