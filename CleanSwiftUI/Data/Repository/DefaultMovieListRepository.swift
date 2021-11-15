//
//  DefaultMovieListRepository.swift
//  CleanSwiftUI
//
//  Created by Rokon on 11/15/21.
//

import Foundation
import Combine
import CoreData
import Moya

class DefaultMovieListRepository: MovieListRepository {

    private let network: MovieNetworking

    init(network: MovieNetworking = MovieNetworking.defaultNetworking()) {
        self.network = network
    }

    func getMovieList(page: Int) -> AnyPublisher<MovieList, NetworkingError> {
        return network.requestObject(.trending, type: MovieList.self)
    }
}
