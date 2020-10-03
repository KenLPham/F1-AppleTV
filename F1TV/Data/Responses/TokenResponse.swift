//
//  TokenResponse.swift
//  F1TV
//
//  Created by Ken Pham on 7/2/20.
//  Copyright © 2020 Phez Technologies. All rights reserved.
//

import Foundation

public struct TokenResponse: Decodable {
	enum CodingKeys: String, CodingKey {
		case token, accessToken = "oauth2_access_token", urls = "plan_urls", vip = "user_is_vip"
	}
	
	let token: String
	let accessToken: String
	let urls: [String]
	let vip: Bool
}
