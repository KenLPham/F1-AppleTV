//
//  Credentials.swift
//  F1TV
//
//  Created by Ken Pham on 7/2/20.
//  Copyright © 2020 Phez Technologies. All rights reserved.
//

import Foundation

struct Credentials: Codable {
	enum CodingKeys: String, CodingKey {
		case email = "Login", password = "Password"
	}
	
	var email: String
	var password: String
	
	init () {
		self.email = ""
		self.password = ""
	}
	
	func challenge () -> URLCredential {
		URLCredential(user: email, password: password, persistence: .forSession)
	}
}

#if DEBUG
extension Credentials: CustomDebugStringConvertible {
	var debugDescription: String {
		"""
		{
			"email": \(email),
			"password": \(password)
		}
		"""
	}
}
#endif
