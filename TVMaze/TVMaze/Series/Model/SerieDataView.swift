//
//  SerieDataView.swift
//  TVMaze
//
//  Created by Juan david Lopera lopez on 21/04/25.
//

import Foundation

struct SerieDataView: Hashable {
    var id: Int
    var title: String
    var language: String
    var genres: String
    var scheduleDays: String
    var scheduleTime: String
    var summary: String
    var image: URL?
}
