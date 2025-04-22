//
//  SerieEpisodes.swift
//  TVMaze
//
//  Created by Juan david Lopera lopez on 21/04/25.
//

import Foundation

struct SerieEpisodes: Decodable {
    var id: Int
    var name: String
    var season: Int
    var number: Int
    var summary: String
    var image: SerieImage
}
