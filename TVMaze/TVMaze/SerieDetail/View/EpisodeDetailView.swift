//
//  EpisodeDetailView.swift
//  TVMaze
//
//  Created by Juan david Lopera lopez on 23/04/25.
//

import Kingfisher
import SwiftUI

struct EpisodeDetailView: View {
    let episode: EpisodeViewData

    var body: some View {
        VStack(spacing: 20) {
            Text("\(episode.season)")
            Text("\(episode.number)")
                .font(.title2)
                .bold()
            KFImage(episode.img)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 200)

            Text(episode.name)
                .font(.title)
                .bold()
            Text(episode.summary)
                .padding()
            Spacer()
        }
        .padding()
    }
}

#Preview {
    EpisodeDetailView(episode: EpisodeViewData(season: "", img: nil, name: "", number: "", summary: ""))
}
