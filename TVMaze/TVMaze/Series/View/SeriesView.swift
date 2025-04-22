//
//  SeriesView.swift
//  TVMaze
//
//  Created by Juan david Lopera lopez on 21/04/25. 
//

import Kingfisher
import SwiftUI

struct SeriesView: View {
    
    @ObservedObject var viewModel: SeriesViewModel = SeriesViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                switch viewModel.viewState {
                case .idle:
                    Text("TVMaze App")
                    Text("Dev: Juan David Lopera")
                case .error:
                    Image("error")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200.0, height: 200.0)
                        .padding()
                    Text("Error loading the serie list\nCheck your internet connection and\ntry again.")
                        .modifier(FeaturedTitleStyle())
                        .multilineTextAlignment(.center)
                        .padding(.bottom)
                    Button {
                        viewModel.loadSeries()
                    } label: {
                        Text("Try again")
                    }
                    .buttonStyle(.borderedProminent)
                    .padding(.top)
                    
                case .loading:
                    VStack {
                        Spacer()
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                            .scaleEffect(3.0)
                            .padding(.bottom)
                        Text("Loading...")
                            .modifier(FeaturedTitleStyle())
                            .padding(.top)
                        Spacer()
                    }
                case .loaded:
                    TextField("Search series...", text: $viewModel.searchText)
                        .padding(10)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .padding()
                    ScrollView {
                        LazyVStack {
                            ForEach(viewModel.seriesList, id: \.self) { serie in
                                // Empty View will be replaced with DetailSerieView
                                NavigationLink(destination: EmptyView()) {
                                    HStack {
                                        serieImage(url: serie.image)
                                        displayPrincipalInfo(serie: serie)
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.bottom)
                                }
                            }
                        }
                        .padding()
                    }
                    .simultaneousGesture(DragGesture().onChanged({ _ in
                        UIApplication.shared.hideKeyboard()
                    }))
                }
            }
            .onTapGesture {
                UIApplication.shared.hideKeyboard()
            }
            .onAppear(perform: {
                if viewModel.seriesList.isEmpty {
                    viewModel.loadSeries()
                }
            })
            .navigationTitle("Series")
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
    SeriesView()
}
