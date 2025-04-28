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
    private let objectIndex: Int
    
    // MARK: - Properties Wrapper
    @ObservedObject var viewModel: SeriesViewModel
    @State private var imgName: String = ""
    
    // MARK: - Internal Init
    init(viewModel: SeriesViewModel, objectIndex: Int) {
        self.viewModel = viewModel
        self.objectIndex = objectIndex
    }
    
    var body: some View {
        HStack {
            serieImage(url: viewModel.serie(index: objectIndex).image)
            displayPrincipalInfo(serie: viewModel.serie(index: objectIndex))
            Spacer()
            Image(imgName)
                .resizable()
                .scaledToFit()
                .frame(width: 20.0, height: 20.0)
                .onTapGesture {
                    viewModel.addToFavorite(index: objectIndex)
                    imgName = viewModel.imgName(index: objectIndex)
                }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.bottom)
        .onAppear {
            imgName = viewModel.imgName(index: objectIndex)
        }
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
    SerieRowView(viewModel: SeriesViewModel(), objectIndex: 0)
}
