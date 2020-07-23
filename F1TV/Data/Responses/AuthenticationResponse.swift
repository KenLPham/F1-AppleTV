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

struct AuthenticationResponse: Codable {
	enum CodingKeys: String, CodingKey {
		case session = "SessionId", subscriber = "Subscriber", data
	}
	
	let session: String
	let subscriber: SkySubscriber
	let data: AuthenticationData
	
	func encode () -> Data? {
		try? JSONEncoder.dependency().encode(self)
	}
}

struct SkySubscriber: Codable {
	enum CodingKeys: String, CodingKey {
		case first = "FirstName", last = "LastName", country = "HomeCountry", id = "Id", email = "Email"
	}
	
	let first: String
	let last: String
	let country: String
	let id: Int
	let email: String
	
	var name: String {
		"\(first) \(last)"
	}
}

struct AuthenticationData: Codable {
	enum CodingKeys: String, CodingKey {
		case status = "subscriptionStatus", token = "subscriptionToken"
	}
	
	let status: String
	let token: String
}

#if DEBUG
extension AuthenticationResponse: CustomDebugStringConvertible {
	var debugDescription: String {
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
