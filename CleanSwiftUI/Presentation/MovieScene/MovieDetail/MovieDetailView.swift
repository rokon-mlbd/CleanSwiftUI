//
//  MovieDetailView.swift
//  CleanSwiftUI
//
//  Created by Rokon on 11/15/21.
//

import SwiftUI
import Kingfisher
import Combine

struct MovieDetailView: View {
    private let movieId: Int
    @ObservedObject var viewModel: MovieDetailViewModel
    
    init(movieId: Int, viewModel: MovieDetailViewModel) {
        self.movieId = movieId
        self.viewModel = viewModel
    }
    
    var body: some View {
        let movie = viewModel.movieDetail
        ScrollView {
            VStack {
                fillWidth
                Text(movie.title)
                    .font(.largeTitle)
                    .multilineTextAlignment(.center)
                
                Divider()
                
                HStack {
                    Text(movie.getReleasedAt)
                    Text(movie.getLanguage)
                    Text(movie.getDuration)
                }
                .font(.subheadline)
                
                poster(of: movie)
                
                genres(of: movie)
                
                Divider()
                
                movie.getRating.map {
                    Text($0).font(.body)
                }
                
                Divider()
                
                movie.overview.map {
                    Text($0).font(.body)
                }
            }
        }.onAppear {
            viewModel.apply(.getMovieDetail(id: movieId))
        }
    }
    
    private var fillWidth: some View {
        HStack {
            Spacer()
        }
    }
    
    private func poster(of movie: MovieDetail) -> some View {
        movie.poster.map { url in
            
            KFImage(URL(string: movie.poster?.absoluteString ?? ""))
                .resizable()
                .aspectRatio(contentMode: .fit)
        }
    }
    
    private func genres(of movie: MovieDetail) -> some View {
        HStack {
            ForEach(movie.getGeners, id: \.self) { genre in
                Text(genre)
                    .padding(5)
                    .border(Color.gray)
            }
        }
    }
}

