//
//  SerieRowView.swift
//  TVMaze
//
//  Created by Juan david Lopera lopez on 22/04/25.
//

import Kingfisher
import SwiftUI

struct SerieRowView: View {
    
    // MARK: - Private Properties
    private let serie: SerieDataView
    
    // MARK: - Internal Init
    init(serie: SerieDataView) {
        self.serie = serie
    }
    
    var body: some View {
        HStack {
            serieImage(url: serie.image)
            displayPrincipalInfo(serie: serie)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.bottom)
    }
    
    func serieImage(url: URL?) -> some View {
        KFImage(url)
            .resizable()
            .placeholder {
                Image("popcornplaceHolder")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 160)
            }
            .cancelOnDisappear(true)
            .aspectRatio(contentMode: .fit)
            .frame(width: 100, height: 160)
            .cornerRadius(8)
    }
    
    func displayPrincipalInfo(serie: SerieDataView) -> some View {
        VStack(alignment: .leading) {
            Spacer()
            VStack(alignment: .leading) {
                Text("Title")
                    .modifier(TitleStyle())
                Text(serie.title)
                    .modifier(FeaturedTitleStyle())
            }
            .padding(.bottom, 1)
            
            VStack(alignment: .leading) {
                Text("Language")
                    .modifier(TitleStyle())
                Text(serie.language)
                    .modifier(FeaturedTitleStyle())
            }
            .padding(.bottom, 1)
            
            VStack(alignment: .leading) {
                Text("Genres")
                    .modifier(TitleStyle())
                Text(serie.genres)
                    .modifier(FeaturedTitleStyle())
            }
            Spacer()
        }
    }
}

#Preview {
    SerieRowView(serie: SerieDataView(id: 0, title: "Test", language: "Eng", genres: "Drama, Action", scheduleDays: "Monday", scheduleTime: "22:00", summary: "sumary", image: nil))
}
