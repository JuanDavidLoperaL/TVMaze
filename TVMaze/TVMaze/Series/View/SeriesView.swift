//
//  SeriesView.swift
//  TVMaze
//
//  Created by Juan david Lopera lopez on 21/04/25.
//

import SwiftUI

struct SeriesView: View {
    
    @ObservedObject var viewModel: SeriesViewModel = SeriesViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack {
                    // Empty View will be replaced with DetailSerieView
                    ForEach(viewModel.seriesList, id: \.self) { serie in
                        NavigationLink(destination: EmptyView()) {
                            HStack {
                                Image(uiImage: serie.image)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100, height: 160)
                                    .background(Color.blue)
                                displayPrincipalInfo(serie: serie)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.bottom)
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Series")
        }
    }
    
    func displayPrincipalInfo(serie: SerieDataView) -> some View {
        VStack(alignment: .leading) {
            Spacer()
            VStack(alignment: .leading) {
                Text("Title")
                    .font(.system(size: 14.0, weight: .regular))
                Text(serie.title)
                    .font(.system(size: 17, weight: .bold))
            }
            .padding(.bottom, 1)

            VStack(alignment: .leading) {
                Text("Language")
                    .font(.system(size: 14.0, weight: .regular))
                Text(serie.language)
                    .font(.system(size: 17, weight: .bold))
            }
            .padding(.bottom, 1)
            
            VStack(alignment: .leading) {
                Text("Genres")
                    .font(.system(size: 14.0, weight: .regular))
                Text(serie.genres)
                    .font(.system(size: 17, weight: .bold))
            }
            Spacer()
        }
    }
}

#Preview {
    SeriesView()
}
