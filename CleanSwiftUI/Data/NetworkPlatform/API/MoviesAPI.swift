//
//  MoviesAPI.swift
//  CleanSwiftUI
//
//  Created by Rokon on 11/15/21.
//

import Moya
import Foundation


enum MoviesAPI {
    case trending
    case details(id: Int)
}

extension MoviesAPI: TargetType, ProductAPIType {
    static let imageBase = URL(string: "https://image.tmdb.org/t/p/original/")!
    // TODO: store securely
    static private let apiKey = "efb6cac7ab6a05e4522f6b4d1ad0fa43"

    var baseURL: URL {
        return URL(string: "https://api.themoviedb.org/3")!
    }

    var path: String {
        switch self {
        case .trending:
            return "trending/movie/week"
        case .details(let id):
            return "movie/\(id)"
        }
    }

    var method: Moya.Method {
        return .get
    }

    var parameters: [String: Any] {
        var params: [String: Any] = [:]
        switch self {
        case .trending:
            params["api_key"] = MoviesAPI.apiKey
        case .details(_):
            params["api_key"] = MoviesAPI.apiKey
        }
        return params
    }

    public var parameterEncoding: ParameterEncoding {
        return URLEncoding.default
    }

    var task: Task {
        if !parameters.isEmpty {
            return .requestParameters(parameters: parameters, encoding: parameterEncoding)
        } else {
            return .requestPlain
        }
    }

    var sampleData: Data {
        switch self {
        case .trending:
            return stubbedResponse("Trending")
        case .details(_):
            return stubbedResponse("Details")
        }
    }

    var headers: [String: String]? {
        return nil
    }

    func stubbedResponse(_ filename: String) -> Data! {
        let bundlePath = Bundle.main.path(forResource: "Stub", ofType: "bundle")
        let bundle = Bundle(path: bundlePath!)
        let path = bundle?.path(forResource: filename, ofType: "json")
        return (try? Data(contentsOf: URL(fileURLWithPath: path!)))
    }

    var addXAuth: Bool {
        switch self {
        default: return false
        }
    }
}



