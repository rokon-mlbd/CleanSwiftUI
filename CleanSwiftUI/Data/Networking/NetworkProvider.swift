//
//  NetworkProvider.swift
//  CleanSwiftUI
//
//  Created by Rokon on 11/15/21.
//

import Foundation
// TODO: has no use yet. Will work in futur
final class NetworkProvider {
    public func makeMovieNetwork() -> MovieNetworking {
        return MovieNetworking.defaultNetworking()
    }
}

