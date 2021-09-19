//
//  Lite.swift
//  F1TV
//
//  Created by Kenneth Pham on 3/10/21.
//  Copyright © 2021 Phez Technologies. All rights reserved.
//

import SwiftUI
import Combine

public typealias APIPublisher<R: Decodable> = AnyPublisher<R, Lite.Errors>

extension JSONDecoder {
    static let apiDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
//        decoder.dateDecodingStrategy = .iso8601
        decoder.dateDecodingStrategy = .millisecondsSince1970
        return decoder
    }()
}

extension JSONEncoder {
    static let apiEncoder: JSONEncoder = {
        let decoder = JSONEncoder()
        return decoder
    }()
}

public class Lite: NSObject {
    @Environment(\.appState) var appState
    @Environment(\.authorized) var authorize
    
    private var session = URLSession.shared
    private var decoder = JSONDecoder.apiDecoder
    private var encoder = JSONEncoder.apiEncoder
    
    private var baseUrl = "https://f1tv.formula1.com"
    private var authUrl = "https://api.formula1.com/v2/account/subscriber/authenticate/by-password"
    
    private let format = StreamType.bigScreen
    
    public override init () {
        super.init()

        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = [
            // from dotd voting: apiKey=qPgPPRJyGCIPxFT3el4MF7thXHyJCzAP
            "apiKey": "fCUCjWrKPu9ylJwRAv8BpGLEgiAuThx7",
            "Content-Type": "application/json",
            // they're checking User-Agent for "RaceControl" ...
            "User-Agent": "RaceControl F1TV for AppleTV"
        ]
        
        self.session = URLSession(configuration: config, delegate: self, delegateQueue: OperationQueue())
    }
}

// MARK: - Authentication
extension Lite {
    public func authenticate (with credentials: Credentials) -> APIPublisher<AuthenticationResponse> {
        self.request(.post, url: authUrl, body: credentials).decode(with: decoder)
    }
}

// MARK: - API Methods
extension Lite {
    // MARK: MENU
    func getMenu () -> AnyPublisher<APIResponse<ResultObject<MenuContainer>>, Errors> {
        self.request(.get, path: "/2.0/R/ENG/\(format.hls)/ALL/MENU/F1_TV_Pro_Annual/2").decode(with: decoder)
    }
    
    // MARK: PAGE
    func getPage (forId pageId: Int) -> AnyPublisher<APIResponse<ResultObject<PageContainer>>, Errors> {
        self.getPage(atPath: "/2.0/R/ENG/\(format.hls)/ALL/PAGE/\(pageId)/F1_TV_Pro_Annual/2")
    }
    
    func getPage (atPath path: String) -> AnyPublisher<APIResponse<ResultObject<PageContainer>>, Errors> {
        self.request(.get, path: path).decode(with: decoder)
    }
    
    // MARK: CONTENT
    
    
    /// - TODO: Remove

    /// - TODO: use uri from action?
    func getDetailContainers (_ contentId: String) -> AnyPublisher<ContentContainer<Int>?, Errors> {
        self.getContentDetails(format: .bigScreen, id: contentId).map(\.resultObj.containers.first).eraseToAnyPublisher()
    }
    
    func getPlaybackUrl (_ contentId: String) -> AnyPublisher<PlaybackResultObject, Errors> {
        self.getPlaybackUrl(format: .bigScreen, id: contentId).map(\.resultObj).eraseToAnyPublisher()
    }
    
    func getPerspectivePlaybackUrl (_ path: String) -> AnyPublisher<PlaybackResultObject, Errors> {
        self.getPerspectivePlaybackUrl(format: .bigScreen, path: path).map(\.resultObj).eraseToAnyPublisher()
    }
    
    // MARK: Helper Methods
    func getContentDetails (format: StreamType, id contentId: String) -> AnyPublisher<APIResponse<ResultObject<ContentContainer<Int>>>, Errors> {
        self.request(.get, path: "/2.0/R/ENG/\(format.hls)/ALL/CONTENT/VIDEO/\(contentId)/F1_TV_Pro_Annual/14").decode(with: decoder)
    }
    
    func getPlaybackUrl (format: StreamType, id contentId: String) -> AnyPublisher<APIResponse<PlaybackResultObject>, Errors> {
        self.request(.get, path: "/1.0/R/ENG/\(format.hls)/ALL/CONTENT/PLAY", parameters: [ "contentId": contentId ], token: authorize.session?.data.token).decode(with: decoder)
    }
    
    func getPerspectivePlaybackUrl (format: StreamType, path: String) -> AnyPublisher<APIResponse<PlaybackResultObject>, Errors> {
        self.request(.get, path: "/1.0/R/ENG/\(format.hls)/ALL/\(path)", token: authorize.session?.data.token).decode(with: decoder)
    }
}

// MARK: - Request Methods
extension Lite {
    private func request (_ method: HTTPMethod, path: String, parameters: [String: String] = [:], token: String? = nil) -> AnyPublisher<Data, Errors> {
        let request = self.makeRequest(url: "\(baseUrl)\(path)", parameters: parameters, token: token, method: method)
        return self.runTask(with: request)
    }
    
    private func request (_ method: HTTPMethod, url: String, parameters: [String: String] = [:], token: String? = nil) -> AnyPublisher<Data, Errors> {
        let request = self.makeRequest(url: url, parameters: parameters, token: token, method: method)
        return self.runTask(with: request)
    }
    
    private func request<T: Encodable> (_ method: HTTPMethod, url: String, parameters: [String: String] = [:], body: T, token: String? = nil) -> AnyPublisher<Data, Errors> {
        var request = self.makeRequest(url: url, parameters: parameters, token: token, method: method)
        do {
            request.httpBody = try encoder.encode(body)
        } catch {
            return Fail(error: Errors.request(error)).eraseToAnyPublisher()
        }
        return self.runTask(with: request)
    }
}

// MARK: - Helper Methods
extension Lite {
    private func makeRequest (url: String, parameters: [String: String]?, token: String?, method: HTTPMethod) -> URLRequest {
        var components = URLComponents(string: url)
        if let param = parameters {
            let queryItems = self.buildQueryItems(from: param)
            if components?.queryItems == nil {
                components?.queryItems = queryItems
            } else {
                components?.queryItems?.append(contentsOf: queryItems)
            }
        }
        guard let url = components?.url else { fatalError("Invalid URL") }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        if let t = token {
            print("token", t)
            request.setValue(t, forHTTPHeaderField: "ascendontoken")
        }
        
        return request
    }
    
    private func runTask (with request: URLRequest) -> AnyPublisher<Data, Errors> {
        print("[\(request.httpMethod ?? "<error>")] \(request.url?.absoluteString ?? "<error>")")
        
        return session.dataTaskPublisher(for: request).tryMap { result in
            let statusCode = (result.response as? HTTPURLResponse)?.statusCode
            
            // MARK: DEBUGGING
            print("response [\(statusCode ?? -1)]: \(String(data: result.data, encoding: .utf8) ?? "<nil>")")
            
            if case (200..<300)? = statusCode {
                return result.data
            } else if statusCode == 401 {
                // reauthenticate
                self.authorize.authenticate()
                // - TODO: retry request rather than throw an error
                throw Errors.unauthorized
            } else {
                throw Errors.api(String(data: result.data, encoding: .utf8))
            }
        }.mapError {
            switch $0 {
            case let urlError as URLError:
                return Errors.connection(urlError)
            case let skylarkError as Errors:
                return skylarkError
            case let decodeError as DecodingError:
                return Errors.parse(decodeError)
            default:
                return Errors.unknown($0)
            }
        }.eraseToAnyPublisher()
    }
    
    private func buildQueryItems (from parameters: [String: String]) -> [URLQueryItem] {
        return parameters.reduce(into: [URLQueryItem]()) { (result, obj) in
            if let encoded = obj.value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                result.append(URLQueryItem(name: obj.key, value: encoded))
            }
        }
    }
}

extension Lite {
    // MARK: - Errors
    public enum Errors: Error {
        case unauthorized
        case connection(URLError)
        case parse(DecodingError)
        case api(String?)
        case unknown(Error)
        /// Error thrown when request body fails to be encoded
        case request(Error)
    }
    
    // MARK: - Types
    public enum HTTPMethod: String {
        case get, put, post, delete
    }
    
    private typealias EncodedResult = Result<Data, Errors>
    private typealias EncodedHandler = (EncodedResult) -> ()
    public typealias LiteHandler<T: Decodable> = (Result<T, Errors>) -> ()
}

// MARK: - Publisher Extension
extension AnyPublisher where Output == Data, Failure == Lite.Errors {
    @inlinable func decode<R: Decodable> (with decoder: JSONDecoder) -> APIPublisher<R> {
        self.decode(type: R.self, decoder: decoder).mapError {
            switch $0 {
            case let liteErrors as Lite.Errors:
                return liteErrors
            case let decodeError as DecodingError:
                return Lite.Errors.parse(decodeError)
            default:
                return Lite.Errors.unknown($0)
            }
        }.eraseToAnyPublisher()
    }
}

public extension AnyPublisher {
    @inlinable func handleErrors (_ handler: @escaping (Failure) -> ()) -> AnyPublisher<Output, Never> {
        self.mapErrorToNil(handler).compactMap { $0 }.eraseToAnyPublisher()
    }
    
    @inlinable func mapErrorToNil (_ handler: ((Failure) -> ())? = nil) -> AnyPublisher<Output?, Never> {
        self.map { output -> Output? in
            output
        }.catch { error -> Just<Output?> in
            handler?(error)
            return Just(nil)
        }.eraseToAnyPublisher()
    }
}

// MARK: - Environment Extension
extension Lite {
    struct Key: EnvironmentKey {
        static var defaultValue = Lite()
    }
}

extension EnvironmentValues {
    var apiClient: Lite {
        get {
            self[Lite.Key.self]
        }
        set {
            self[Lite.Key.self] = newValue
        }
    }
}

// not really needed
extension Lite: URLSessionTaskDelegate {}
