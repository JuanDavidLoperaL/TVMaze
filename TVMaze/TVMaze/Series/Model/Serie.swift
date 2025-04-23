//
//  Serie.swift
//  TVMaze
//
//  Created by Juan david Lopera lopez on 21/04/25.
//

import Foundation

struct Serie: Decodable {
    var id: Int
    var name: String
    var language: String
    var genres: [String]
    var summary: String
    var schedule: SerieSchedule
    var image: SerieImage?
}
