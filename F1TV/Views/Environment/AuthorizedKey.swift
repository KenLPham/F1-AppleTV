//
//  AuthorizedKey.swift
//  F1TV
//
//  Created by Ken Pham on 7/2/20.
//  Copyright © 2020 Phez Technologies. All rights reserved.
//

import SwiftUI
import KeychainAccess

extension Data {
	func decode<T: Decodable> (to type: T.Type) -> T? {
		try? JSONDecoder.dependency().decode(type, from: self)
	}
}

class AuthorizedObject: ObservableObject {
	private var keychain = Keychain(service: "com.kpham.auth")
	
	@Published var credentials: AuthenticationResponse?
	
	init () {
		self.credentials = try? keychain.getData("credentials")?.decode(to: AuthenticationResponse.self)
	}
	
	func store (_ credentials: AuthenticationResponse?) {
		self.credentials = credentials
		if let data = credentials?.encode() {
			try? keychain.set(data, key: "credentials")
		} else {
			try? keychain.remove("credentials")
		}
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
