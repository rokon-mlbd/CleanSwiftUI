//
//  MovieListUseCase.swift
//  CleanSwiftUI
//
//  Created by Rokon on 11/15/21.
//

import Foundation
import Combine
import Moya

protocol MovieListUseCase {
    func execute(page: Int) -> AnyPublisher<MovieList, NetworkingError>
}

final class DefaultMovieListUseCase: MovieListUseCase {
    private let repository: MovieListRepository

    init(repository: MovieListRepository) {
        self.repository = repository
    }

    func execute(page: Int) -> AnyPublisher<MovieList, NetworkingError> {
        return repository.getMovieList(page: page)
    }
}


