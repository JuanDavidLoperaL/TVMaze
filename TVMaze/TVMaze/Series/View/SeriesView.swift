//
//  SeriesView.swift
//  TVMaze
//
//  Created by Juan david Lopera lopez on 21/04/25.
//

import Kingfisher
import SwiftUI

struct SeriesView: View {
    
    @StateObject var viewModel: SeriesViewModel = SeriesViewModel()

    
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
                    ScrollView(.vertical, showsIndicators: false) {
                        LazyVStack {
                            ForEach(viewModel.seriesList.indices, id: \.self) { index in
                                let serie = viewModel.seriesList[index]
                                NavigationLink(destination: SerieDetailView(viewModel: SerieDetailViewModel(serieDataView: serie))) {
                                    SerieRowView(serie: serie)
                                }
                                .onAppear {
                                    if index >= viewModel.seriesList.count - 5 {
                                        viewModel.loadSeries()
                                    }
                                }
                            }
                            if viewModel.viewState == .loading && viewModel.hasMoreData {
                                ProgressView("Loading more...")
                                    .padding()
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
}

#Preview {
    SeriesView()
}
