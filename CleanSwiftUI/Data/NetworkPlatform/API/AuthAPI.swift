//
//  AuthAPI.swift
//  CleanSwiftUI
//
//  Created by Rokon on 11/15/21.
//

import Moya
import Foundation

enum AuthAPI {
    case accessToken
}

extension AuthAPI: TargetType, ProductAPIType {
    var baseURL: URL {
        return URL(string: "https://api.punkapi.com/v2/token")!
    }

    var path: String {
        switch self {
        case .accessToken:
            return "/access_token"
        }
    }

    var method: Moya.Method {
        return .get
    }

    var task: Task {
        switch self {
        default:
            return .requestPlain
        }
    }

    var sampleData: Data {
        switch self {
        case .accessToken:
            return stubbedResponse("AccessToken")
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
        default: return true
        }
    }
}


