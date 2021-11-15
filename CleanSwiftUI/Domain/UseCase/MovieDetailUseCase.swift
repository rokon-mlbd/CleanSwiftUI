//
//  MovieDetailUseCase.swift
//  CleanSwiftUI
//
//  Created by Rokon on 11/15/21.
//

import Foundation
import Combine
import Moya

protocol MovieDetailUseCase {
    func execute(movieId: Int) -> AnyPublisher<MovieDetail, NetworkingError>
}

final class DefaultMovieDetailUseCase: MovieDetailUseCase {
    private let repository: MovieDetailRepository

    init(repository: MovieDetailRepository) {
        self.repository = repository
    }

    func execute(movieId: Int) -> AnyPublisher<MovieDetail, NetworkingError> {
        return repository.movieWithId(movieId)
    }
}

