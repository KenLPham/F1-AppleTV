//
//  Skylark.swift
//  F1TV
//
//  Created by Ken Pham on 7/2/20.
//  Copyright © 2020 Phez Technologies. All rights reserved.
//

import SwiftUI
import Combine

extension JSONEncoder {
    static var dependency: () -> JSONEncoder = JSONEncoder.init
}

extension JSONDecoder {
    static var dependency: () -> JSONDecoder = JSONDecoder.init
}

public typealias APIPublisher<R: Decodable> = AnyPublisher<R, Skylark.Errors>

public class Skylark: NSObject {
    @Environment(\.appState) var appState
	@Environment(\.authorized) var authorize
	
	private var session: URLSession = .shared
    private var decoder = JSONDecoder()
    private var encoder = JSONEncoder()
	
	private var baseUrl = "https://f1tv.formula1.com"
	
	public override init () {
		super.init()
        
        decoder.dateDecodingStrategy = .iso8601
		
		let config = URLSessionConfiguration.default
		config.httpAdditionalHeaders = [
            // from dotd voting: apiKey=qPgPPRJyGCIPxFT3el4MF7thXHyJCzAP
			"apiKey": "fCUCjWrKPu9ylJwRAv8BpGLEgiAuThx7",
			"Content-Type": "application/json",
            "User-Agent": "RaceControl F1TV for AppleTV" // they're checking User-Agent for "RaceControl" ...
		]
		
		self.session = URLSession(configuration: config, delegate: self, delegateQueue: OperationQueue())
	}
	
	// MARK: Authentication
    public func authenticate (with credentials: Credentials) -> APIPublisher<AuthenticationResponse> {
        request(.post, url: "https://api.formula1.com/v2/account/subscriber/authenticate/by-password", body: credentials).decode(with: decoder)
	}
	
    public func getToken (_ access: String) -> APIPublisher<TokenResponse> {
        request(.post, url: "https://f1tv-api.formula1.com/agl/1.0/unk/en/all_devices/global/authenticate", body: TokenRequest(token: access)).decode(with: decoder)
	}
	
	// MARK: RACE 👏 WEEKEND 👏
    public func getLive () -> APIPublisher<LiveResponse> {
		let parameters = [
			"fields": "items",
			"slug": "grand-prix-weekend-live"
		]
        return request(.get, path: "/api/sets", parameters: parameters).decode(with: decoder)
	}
	
	// MARK: Archive
    public func getSeasons () -> APIPublisher<SeasonsResponse> {
		let parameters = [
			"fields": "name,has_content,eventoccurrence_urls,schedule_urls,uid",
			"order": "-year",
            "year__gt": "2017" // greater than = gt, less than = lt, equal = "year": "2017"
		]
        return request(.get, path: "/api/race-season", parameters: parameters).decode(with: decoder)
	}
	
    public func getEvent (_ path: String) -> APIPublisher<EventResponse> {
		let parameters = [
			"fields": "official_name,sessionoccurrence_urls,image_urls,uid,name,start_date"
		]
        return request(.get, path: path, parameters: parameters).decode(with: decoder)
	}
	
    public func getSession (_ path: String) -> APIPublisher<SessionResponse> {
		let parameters = [
			"fields": "name,status,uid,session_name,image_urls,uid,start_time,channel_urls,series_url"
		]
        return request(.get, path: path, parameters: parameters).decode(with: decoder)
	}
	
    public func getChannel (_ path: String) -> APIPublisher<ChannelResponse> {
		let parameters = [
			"fields": "driveroccurrence_urls,uid,channel_type,name,self"
		]
        return request(.get, path: path, parameters: parameters).decode(with: decoder)
	}
	
    public func loadStream (from key: String) -> APIPublisher<StreamResponse> {
		guard let credentails = authorize.credentials else {
            appState.option = .notAuthorized
            return Fail(error: Errors.unauthorized).eraseToAnyPublisher()
        }
        
        return getToken(credentails.data.token).flatMap {
            self.request(.post, url: "https://f1tv.formula1.com/api/viewings/", body: StreamRequest(channel: key), token: $0.token)
        }.eraseToAnyPublisher().decode(with: decoder)
	}
	
	// MARK: - Helper Methods
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
    
    // MARK: - Helper Methods
    private func makeRequest (url: String, parameters: [String: String]?, token: String?, method: HTTPMethod) -> URLRequest {
        var components = URLComponents(string: url)
        if let param = parameters {
            components?.queryItems = self.buildQueryString(from: param)
        }
        guard let url = components?.url else { fatalError("Invalid URL") }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        if let t = token {
            request.setValue("JWT \(t)", forHTTPHeaderField: "Authorization")
        }
        
        return request
    }
	
	private func runTask (with request: URLRequest) -> AnyPublisher<Data, Errors> {
        session.dataTaskPublisher(for: request).tryMap { result in
            let statusCode = (result.response as? HTTPURLResponse)?.statusCode
            
            // MARK: DEBUGGING
            print("response [\(statusCode ?? -1)]: \(String(data: result.data, encoding: .utf8) ?? "<nil>")")
            
            if case (200..<300)? = statusCode {
                return result.data
            } else if statusCode == 401 {
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
	
    private func buildQueryString (from parameters: [String: String]) -> [URLQueryItem] {
        return parameters.reduce(into: [URLQueryItem]()) { (result, obj) in
            if let encoded = obj.value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                result.append(URLQueryItem(name: obj.key, value: encoded))
            }
        }
    }
}

extension Skylark {
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
    public typealias SkyHandler<T: Decodable> = (Result<T, Errors>) -> ()
}

// MARK: - Publisher Extension
extension AnyPublisher where Output == Data, Failure == Skylark.Errors {
    @inlinable func decode<R: Decodable> (with decoder: JSONDecoder) -> APIPublisher<R> {
        self.decode(type: R.self, decoder: decoder).mapError {
            switch $0 {
            case let skylarkErrors as Skylark.Errors:
                return skylarkErrors
            case let decodeError as DecodingError:
                return Skylark.Errors.parse(decodeError)
            default:
                return Skylark.Errors.unknown($0)
            }
        }.eraseToAnyPublisher()
    }
}

// MARK: - Environment Extension
extension Skylark {
    struct Key: EnvironmentKey {
        static var defaultValue = Skylark()
    }
}

extension EnvironmentValues {
    var apiClient: Skylark {
        get {
            self[Skylark.Key.self]
        }
        set {
            self[Skylark.Key.self] = newValue
        }
    }
}

// not really needed
extension Skylark: URLSessionTaskDelegate {}
