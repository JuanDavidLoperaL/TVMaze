//
//  EpisodeViewData.swift
//  TVMaze
//
//  Created by Juan david Lopera lopez on 23/04/25.
//

import Foundation

struct EpisodeViewData: Hashable, Identifiable {
    let id = UUID()
    var season: String
    var img: URL?
    var name: String
    var number: String
    var summary: String
}
