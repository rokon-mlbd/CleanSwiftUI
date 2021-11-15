//
//  MovieDetailRepository.swift
//  CleanSwiftUI
//
//  Created by Rokon on 11/15/21.
//

import Foundation
import Combine
import Moya

protocol MovieDetailRepository {
    func movieWithId(_ id: Int) -> AnyPublisher<MovieDetail, NetworkingError>
}

