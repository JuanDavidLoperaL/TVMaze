//
//  SeriesViewModel.swift
//  TVMaze
//
//  Created by Juan david Lopera lopez on 21/04/25.
//

import Foundation
import UIKit

final class SeriesViewModel: ObservableObject {
    @Published var seriesList: [SerieDataView] = [SerieDataView(title: "Under the Dome", language: "Eng, Esp", genres: "Action, Drama, Crime", image: UIImage()), SerieDataView(title: "Person of Interest", language: "Eng, Esp", genres: "Action, Drama, Crime", image: UIImage())]
}
