//
//  SerieDetailView.swift
//  TVMaze
//
//  Created by Juan david Lopera lopez on 22/04/25.
//

import Kingfisher
import SwiftUI

struct SerieDetailView: View {
    
    // MARK: - Private Properties
    @ObservedObject var viewModel: SerieDetailViewModel
    @State private var selectedEpisode: EpisodeViewData? = nil
    
    // MARK: - Internal Init
    init(viewModel: SerieDetailViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack {
                serieHeader(serie: viewModel.serieDataView)
                serieInfo(serie: viewModel.serieDataView)
            }.padding()
            serieEpisodes()
            Spacer()
        }
        .onAppear {
            viewModel.loadEpisodes()
        }
    }
    
    func serieHeader(serie: SerieDataView) -> some View {
        VStack {
            Text(serie.title)
                .modifier(FeaturedTitleStyle())
            KFImage(serie.image)
                .resizable()
                .placeholder {
                    Image("popcornplaceHolder")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120, height: 200)
                }
                .cancelOnDisappear(true)
                .aspectRatio(contentMode: .fit)
                .frame(width: 120, height: 200)
                .cornerRadius(8)
        }
    }
    
    func serieInfo(serie: SerieDataView) -> some View {
        VStack {
            Text("Genre")
                .modifier(FeaturedTitleStyle())
            Text(serie.genres)
            Text("Days")
                .modifier(FeaturedTitleStyle())
                .padding(.top, 2)
            Text(serie.scheduleDays)
            Text("Time")
                .modifier(FeaturedTitleStyle())
                .padding(.top, 2)
            Text(serie.scheduleTime)
            Text("Summary")
                .modifier(FeaturedTitleStyle())
                .padding(.top)
            ExpandableText(text: viewModel.cleanSummary(), lineLimit: 2)
        }
    }
    
    func serieEpisodes() -> some View {
        VStack {
            Text(viewModel.episodesTitle)
                .modifier(FeaturedTitleStyle())
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack {
                    ForEach(viewModel.episodesList, id: \.self) { episode in
                        VStack {
                            Text(episode.season)
                                .modifier(FeaturedTitleStyle())
                                .padding(.top, 10)
                            KFImage(episode.img)
                                .resizable()
                                .placeholder {
                                    Image("popcornplaceHolder")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 160.0, height: 100.0)
                                }
                                .cancelOnDisappear(true)
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 160.0, height: 100.0)
                            Text(episode.name)
                                .modifier(FeaturedTitleStyle())
                            Text(episode.number)
                            Text(episode.summary)
                                .lineLimit(2)
                                .truncationMode(.tail)
                                .padding(.horizontal, 8)
                        }
                        .background(Color.gray)
                        .cornerRadius(12)
                        .shadow(color: Color.black.opacity(0.5), radius: 6, x: 0, y: 4)
                        .frame(width: 180)
                        .padding()
                        .onTapGesture {
                            selectedEpisode = episode
                        }
                    }
                }
            }
            .padding(.horizontal, 16)
        }
        .sheet(item: $selectedEpisode) { episode in
            EpisodeDetailView(episode: episode)
        }
    }
}

#Preview {
    SerieDetailView(viewModel: SerieDetailViewModel(serieDataView: SerieDataView(id: 0, title: "Test Title", language: "Eng", genres: "Drama, Action", scheduleDays: "Monday", scheduleTime: "22:00", summary: "sumary sumary", image: nil)))
}
