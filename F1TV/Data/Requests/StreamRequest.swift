//
//  StreamRequest.swift
//  F1TV
//
//  Created by Ken Pham on 7/2/20.
//  Copyright © 2020 Phez Technologies. All rights reserved.
//

import Foundation

struct StreamRequest: Encodable {
	enum CodingKeys: String, CodingKey {
		case channel = "channel_url"
	}
	
	let channel: String
}
