//
//  TokenRequest.swift
//  F1TV
//
//  Created by Ken Pham on 7/2/20.
//  Copyright © 2020 Phez Technologies. All rights reserved.
//

import Foundation

struct TokenRequest: Encodable {
	enum CodingKeys: String, CodingKey {
		case provider = "identity_provider_url", token = "access_token"
	}
	
	let provider = "/api/identity-providers/iden_732298a17f9c458890a1877880d140f3/"
	let token: String
}
