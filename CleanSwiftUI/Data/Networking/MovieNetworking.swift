//
//  MovieNetworking.swift
//  CleanSwiftUI
//
//  Created by Rokon on 11/15/21.
//

import Foundation
import Moya
import Combine
import Alamofire
import CombineMoya


struct MovieNetworking: NetworkingType {
    typealias T = MoviesAPI
    let provider: OnlineProvider<T>

    static func defaultNetworking() -> Self {
        return MovieNetworking(provider: OnlineProvider(endpointClosure: MovieNetworking.endpointsClosure(nil),
                                                        requestClosure: MovieNetworking.endpointResolver(),
                                                        stubClosure: MovieNetworking.APIKeysBasedStubBehaviour,
                                                        plugins: plugins, online: Just(true).setFailureType(to: Never.self).eraseToAnyPublisher()))
    }

    static func stubbingNetworking() -> Self {
        return MovieNetworking(provider: OnlineProvider(endpointClosure: endpointsClosure(),
                                                        requestClosure: MovieNetworking.endpointResolver(),
                                                        stubClosure: MoyaProvider.immediatelyStub,
                                                        online: Just(true).setFailureType(to: Never.self).eraseToAnyPublisher()))
    }
}
