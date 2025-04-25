//
//  CharacterEpisodeDetailResponse.swift
//  TVMaze
//
//  Created by Juan david Lopera lopez on 24/04/25.
//

import Foundation

struct CharacterEpisodeDetailResponse: Decodable {
    var id: Int
    var name: String
    var image: SerieImage?
    var url: String
}
