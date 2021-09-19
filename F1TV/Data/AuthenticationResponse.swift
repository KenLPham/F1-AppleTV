//
//  AuthenticationResponse.swift
//  F1TV
//
//  Created by Ken Pham on 7/2/20.
//  Copyright © 2020 Phez Technologies. All rights reserved.
//

import Foundation

/** Unauthorized Response
{
    "ContextId": "ff632b59-c748-41b8-8ff8-ac342f153157",
    "Code": {
        "Severity": 4,
        "Value": 117,
        "DisplayName": "AccessDenied"
    },
    "ExternalCode": null,
    "PropertyProblems": [],
    "Extensions": {},
    "Type": null,
    "Title": "AccessDenied",
    "Status": 401,
    "Detail": "Access denied",
    "Instance": null
}
*/

public struct AuthenticationResponse: Codable {
	enum CodingKeys: String, CodingKey {
		case session = "SessionId", subscriber = "Subscriber", data
	}
	
    public let session: String
    public let subscriber: SkySubscriber
    public let data: AuthenticationData
    
    public func encode () -> Data? {
        try? JSONEncoder().encode(self)
    }
}

public struct SkySubscriber: Codable {
	enum CodingKeys: String, CodingKey {
		case first = "FirstName", last = "LastName", country = "HomeCountry", id = "Id", email = "Email"
	}
	
    public let first: String
    public let last: String
    public let country: String
    public let id: Int
    public let email: String
	
	var name: String {
		"\(first) \(last)"
	}
}

public struct AuthenticationData: Codable {
	enum CodingKeys: String, CodingKey {
		case status = "subscriptionStatus", token = "subscriptionToken"
	}
	
	let status: String
	let token: String
}

#if DEBUG
extension AuthenticationResponse: CustomDebugStringConvertible {
	public var debugDescription: String {
		"""
		{
			"session_id": \(session),
			"name": \(subscriber.name),
			"token": \(data.token),
			"status": \(data.status)
		}
		"""
	}
}
#endif
