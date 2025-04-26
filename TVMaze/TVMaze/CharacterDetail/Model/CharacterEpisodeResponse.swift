//
//  CharacterEpisodeResponse.swift
//  TVMaze
//
//  Created by Juan david Lopera lopez on 24/04/25.
//

import Foundation

struct CharacterEpisodeResponse: Decodable {
    var embedded: EmbeddedResponse
    
    enum CodingKeys: String, CodingKey {
        case embedded = "_embedded"
    }
}
