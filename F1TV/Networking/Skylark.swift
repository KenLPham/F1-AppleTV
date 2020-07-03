//
//  Skylark.swift
//  F1TV
//
//  Created by Ken Pham on 7/2/20.
//  Copyright © 2020 Phez Technologies. All rights reserved.
//

import SwiftUI

class Skylark: NSObject {
	// MARK: - Types
	public enum HTTPMethod: String {
		case get, put, post, delete
	}
	
	private typealias EncodedResult = Result<Data, Error>
	private typealias EncodedHandler = (EncodedResult) -> ()
	public typealias SkyHandler<T: Decodable> = (Result<T, Error>) -> ()
	
	typealias Decoder = () -> JSONDecoder
	typealias Encoder = () -> JSONEncoder
	
	// MARK: - Skylark API
	@Environment(\.authorized) var authorize
	
	static var shared = Skylark()
	
	private var session: URLSession = .shared
	private var decoder: Decoder
	private var encoder: Encoder
	
	private var baseUrl = "https://f1tv.formula1.com"
	
	init (decoder: @escaping Decoder = JSONDecoder.init, encoder: @escaping Encoder = JSONEncoder.init) {
		self.decoder = decoder
		self.encoder = encoder
		
		super.init()
		
		let config = URLSessionConfiguration.default
		config.httpAdditionalHeaders = [
			"apiKey": "fCUCjWrKPu9ylJwRAv8BpGLEgiAuThx7",
			"Content-Type": "application/json"
		]
		
		self.session = URLSession(configuration: config, delegate: self, delegateQueue: OperationQueue())
	}
	
	func authenticate (with credentials: Credentials, handler: @escaping SkyHandler<AuthenticationResponse>) {
		self.post(url: "https://api.formula1.com/v2/account/subscriber/authenticate/by-password", body: credentials) { [weak self] result in
			self?.decode(result, handler: handler)
		}
	}
	
	func getToken (_ access: String, handler: @escaping SkyHandler<TokenResponse>) {
		let request = TokenRequest(token: access)
		self.post(url: "https://f1tv-api.formula1.com/agl/1.0/unk/en/all_devices/global/authenticate", body: request) { [weak self] result in
			self?.decode(result, handler: handler)
		}
	}
	
	func getSeasons (handler: @escaping SkyHandler<SeasonsResponse>) {
		let parameters = [
			"fields": "name,has_content,eventoccurrence_urls,schedule_urls,uid",
			"order": "-year"
		]
		self.get(path: "/api/race-season", parameters: parameters) { [weak self] result in
			self?.decode(result, handler: handler)
		}
	}
	
	func getEvent (_ path: String, handler: @escaping SkyHandler<EventResponse>) {
		let parameters = [
			"fields": "official_name,sessionoccurrence_urls,image_urls,uid,name,start_date"
		]
		self.get(path: path, parameters: parameters) { [weak self] result in
			self?.decode(result, handler: handler)
		}
	}
	
	func getSession (_ path: String, handler: @escaping SkyHandler<SessionResponse>) {
		let parameters = [
			"fields": "name,status,uid,session_name,image_urls,uid,start_time,channel_urls,series_url"
		]
		self.get(path: path, parameters: parameters) { [weak self] result in
			self?.decode(result, handler: handler)
		}
	}
	
	func getChannel (_ path: String, handler: @escaping SkyHandler<ChannelResponse>) {
		let parameters = [
			"fields": "ovps,driveroccurrence_urls,uid,channel_type,name,self"
		]
		self.get(path: path, parameters: parameters) { [weak self] result in
			self?.decode(result, handler: handler)
		}
	}
	
	func loadStream (from key: String, handler: @escaping SkyHandler<StreamResponse>) {
		guard let credentails = authorize.credentials else { fatalError("Not authorized") } /// - TODO: throw error instead that will lead back to login screen
		
		self.getToken(credentails.data.token) { [weak self] tokenResult in
			switch tokenResult {
			case .success(let response):
				let request = StreamRequest(channel: key)
				self?.post(url: "https://f1tv.formula1.com/api/viewings/", token: response.token, body: request) { [weak self] result in
					self?.decode(result, handler: handler)
				}
			default: ()
			}
		}
	}
	
	// MARK: - Helper Methods
	private func decode<T> (_ result: EncodedResult, handler: @escaping SkyHandler<T>) {
		switch result {
		case .success(let data):
			do {
				let decoder = self.decoder()
				decoder.dateDecodingStrategy = .iso8601
				let response = try decoder.decode(T.self, from: data)
				handler(.success(response))
			} catch {
				handler(.failure(error))
			}
		case .failure(let error):
			handler(.failure(error))
		}
	}
	
	private func get (path: String, parameters: [String: String] = [:], handler: @escaping EncodedHandler) {
		let url = self.baseUrl + path
		var request = URLRequest(url: self.build(url, with: parameters)!)
		request.httpMethod = HTTPMethod.get.rawValue
		self.runTask(with: request, completion: handler)
	}
	
	private func post<T: Encodable> (path: String, parameters: [String: String] = [:], body: T, handler: @escaping EncodedHandler) {
		fatalError("Not implemented")
	}
	
	private func post<T: Encodable> (url: String, parameters: [String: String] = [:], token: String? = nil, body: T, handler: @escaping EncodedHandler) {
		do {
			var request = URLRequest(url: self.build(url, with: parameters)!)
			request.httpMethod = HTTPMethod.post.rawValue
			request.httpBody = try encoder().encode(body)
			
			if let t = token {
				request.setValue("JWT \(t)", forHTTPHeaderField: "Authorization")
			}
			
			self.runTask(with: request, completion: handler)
		} catch {
			print(error.localizedDescription)
		}
	}
	
	private func runTask (with request: URLRequest, completion: @escaping EncodedHandler) {
		let task = session.dataTask(with: request) { (data, response, error) in
			switch (data, response, error) {
			case (_, _, let error?): // connection error
				completion(.failure(error))
			case (let data?, let response?, _):
				let status = (response as? HTTPURLResponse)?.statusCode
				if case (200..<300)? = status {
					print(String(data: data, encoding: .utf8) ?? "<unable to decode>")
					completion(.success(data))
				} else if status == 401 {
					print("unauthorized")
				} else {
					// Error
					print(String(data: data, encoding: .utf8) ?? "<unable to decode>")
				}
			default:
				fatalError("Invalid response combo \(data.debugDescription), \(response.debugDescription) \(error.debugDescription)")
			}
		}
		task.resume()
	}
	
	private func build (_ url: String, with parameters: [String: String]) -> URL? {
		var components = URLComponents(string: url)
		var items = [URLQueryItem]()
		parameters.forEach { (key, value) in
			let item = URLQueryItem(name: key, value: value)
			items.append(item)
		}
		components?.queryItems = items
		return components?.url
	}
}

// not really needed
extension Skylark: URLSessionTaskDelegate {}
