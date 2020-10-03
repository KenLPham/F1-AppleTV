//
//  Credentials.swift
//  F1TV
//
//  Created by Ken Pham on 7/2/20.
//  Copyright © 2020 Phez Technologies. All rights reserved.
//

import Foundation

public struct Credentials: Codable {
	enum CodingKeys: String, CodingKey {
		case email = "Login", password = "Password"
	}
	
    public var email: String
    public var password: String
	
    public init () {
		self.email = ""
		self.password = ""
	}
	
    public func challenge () -> URLCredential {
		URLCredential(user: email, password: password, persistence: .forSession)
	}
}

#if DEBUG
extension Credentials: CustomDebugStringConvertible {
    public var debugDescription: String {
		"""
		{
			"email": \(email),
			"password": \(password)
		}
		"""
	}
}
#endif
