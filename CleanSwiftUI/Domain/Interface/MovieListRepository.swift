//
//  MovieListRepository.swift
//  CleanSwiftUI
//
//  Created by Rokon on 11/15/21.
//

import Foundation
import Combine
import Moya

protocol MovieListRepository {
    func getMovieList(page: Int) -> AnyPublisher<MovieList, NetworkingError>
}

