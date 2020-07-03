//
//  AuthorizedKey.swift
//  F1TV
//
//  Created by Ken Pham on 7/2/20.
//  Copyright © 2020 Phez Technologies. All rights reserved.
//

import SwiftUI

class AuthorizedObject: ObservableObject {
	/// - TODO: store into keychain on set and try getting from keychain on init
	@Published var credentials: AuthenticationResponse?
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
