//
//  DefaultRandomMovieRepository.swift
//  CleanSwiftUI
//
//  Created by Rokon on 11/15/21.
//

import Foundation
import Combine
import CoreData
import Moya

class DefaultMovieDetailRepository: MovieDetailRepository {

    private let network: MovieNetworking

    init(network: MovieNetworking = MovieNetworking.defaultNetworking()) {
        self.network = network
    }

    func movieWithId(_ id: Int) -> AnyPublisher<MovieDetail, NetworkingError> {
        return network.requestObject(.details(id: id), type: MovieDetail.self)
    }
}

