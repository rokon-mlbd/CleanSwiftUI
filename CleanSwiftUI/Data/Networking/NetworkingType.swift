//
//  NetworkingType.swift
//  CleanSwiftUI
//
//  Created by Rokon on 11/14/21.
//

import Foundation
import Moya
import Combine
import Alamofire

protocol ProductAPIType {
    var addXAuth: Bool { get }
}

protocol NetworkingType {
    associatedtype T: TargetType, ProductAPIType
    var provider: OnlineProvider<T> { get }

    static func defaultNetworking() -> Self
    static func stubbingNetworking() -> Self
}

extension NetworkingType {

    static func endpointsClosure<T>(_ xAccessToken: String? = nil) -> (T) -> Endpoint where T: TargetType, T: ProductAPIType {
        return { target in
            let endpoint = MoyaProvider.defaultEndpointMapping(for: target)

            // Sign all non-XApp, non-XAuth token requests
            return endpoint
        }
    }

    static func APIKeysBasedStubBehaviour<T>(_: T) -> Moya.StubBehavior {
        return .never
    }

    static var plugins: [PluginType] {
        var plugins: [PluginType] = []
        //TODO: check logger enable
//        if Configs.Network.loggingEnabled == true {
//            plugins.append(NetworkLoggerPlugin())
//        }
        return plugins
    }

    // (Endpoint<Target>, NSURLRequest -> Void) -> Void
    static func endpointResolver() -> MoyaProvider<T>.RequestClosure {
        return { (endpoint, closure) in
            do {
                var request = try endpoint.urlRequest() // endpoint.urlRequest
                request.httpShouldHandleCookies = false
                closure(.success(request))
            } catch {
                //TODO: print error
//                logError(error.localizedDescription)
            }
        }
    }



    func requestObject<Element: Codable>(_ target: T, type: Element.Type) -> AnyPublisher<Element, NetworkingError> {
        return provider.request(target)
            .filterSuccessfulStatusCodes()
            .map(Element.self)
            .mapError { NetworkingError.error($0.localizedDescription) }
//            .tryCatch { _ in self.coreDataManager.localRandom() }
            .mapError { NetworkingError.error($0.localizedDescription) }
            .eraseToAnyPublisher()
    }




    func requestArray<Element: Codable>(_ target: T, type: Element.Type) -> AnyPublisher<[Element], NetworkingError> {
        provider.request(target)
            .filterSuccessfulStatusCodes()
            .map([Element].self)
            .mapError { NetworkingError.error($0.localizedDescription) }
//            .tryCatch { _ in self.coreDataManager.localRandom() }
            .mapError { NetworkingError.error($0.localizedDescription) }
            .eraseToAnyPublisher()
    }
}


// MARK: - Provider support
func stubbedResponse(_ filename: String) -> Data! {
    @objc class TestClass: NSObject { }

    let bundle = Bundle(for: TestClass.self)
    let path = bundle.path(forResource: filename, ofType: "json")
    return (try? Data(contentsOf: URL(fileURLWithPath: path!)))
}

private extension String {
    var URLEscapedString: String {
        return self.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlHostAllowed)!
    }
}

func url(_ route: TargetType) -> String {
    return route.baseURL.appendingPathComponent(route.path).absoluteString
}

