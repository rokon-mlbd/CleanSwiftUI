//
//  DependencyInjection.swift
//  CleanSwiftUI
//
//  Created by Rokon on 11/13/21.
//

import Foundation

class DependencyInjection {
    static let shared = DependencyInjection()

    func getMovieListView() -> MovieListView {
        let repository = DefaultMovieListRepository()
        let useCase = DefaultMovieListUseCase(repository: repository)
        let viewModel = MovieListViewModel(movieListUseCase: useCase)
        return MovieListView(viewModel: viewModel)
    }

    func getMovieDetailViewForId(_ movieId: Int) -> MovieDetailView {
        let repository = DefaultMovieDetailRepository()
        let useCase = DefaultMovieDetailUseCase(repository: repository)
        let viewModel = MovieDetailViewModel(movieListUseCase: useCase)
        return MovieDetailView(movieId: movieId, viewModel: viewModel)
    }
}

