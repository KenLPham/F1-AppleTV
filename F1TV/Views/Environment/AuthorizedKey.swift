//
//  AuthorizedKey.swift
//  F1TV
//
//  Created by Ken Pham on 7/2/20.
//  Copyright © 2020 Phez Technologies. All rights reserved.
//

import SwiftUI
import SwiftyHelper

extension Data {
	func decode<T: Decodable> (to type: T.Type) -> T? {
		try? JSONDecoder.dependency().decode(type, from: self)
	}
}

class AuthorizedObject: ObservableObject {
	private var keychain = KeychainWrapper(serviceName: "com.kpham.auth", accessGroup: "f1tv")
	
	@Published var credentials: AuthenticationResponse? {
		didSet {
			if let c = credentials?.encode() {
				print(String(data: c, encoding: .utf8))
				keychain.set(c, forKey: "credentials")
			}
		}
	}
	
	init () {
		let stored = keychain.data(forKey: "credentials")?.decode(to: AuthenticationResponse.self)
		self.credentials = stored
		print(stored?.debugDescription)
	}
}

struct AuthorizedKey: EnvironmentKey {
	static let defaultValue = AuthorizedObject()
}

extension EnvironmentValues {
	var authorized: AuthorizedObject {
		get {
			self[AuthorizedKey.self]
		}
		set {
			self[AuthorizedKey.self] = newValue
		}
	}
}
