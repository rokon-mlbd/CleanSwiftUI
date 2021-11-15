//
//  NetworkingError.swift
//  CleanSwiftUI
//
//  Created by Rokon on 11/15/21.
//

import Foundation

enum NetworkingError: Error {
    case error(String)
    case defaultError

    var message: String {
        switch self {
        case let .error(msg):
            return msg
        case .defaultError:
            return "Please try again later."
        }
    }
}
