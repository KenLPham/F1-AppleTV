//
//  StreamResponse.swift
//  F1TV
//
//  Created by Ken Pham on 7/2/20.
//  Copyright © 2020 Phez Technologies. All rights reserved.
//

import Foundation

public struct StreamResponse: Decodable {
	enum CodingKeys: String, CodingKey {
		case url = "tokenised_url"
	}
	
	let url: URL
}
