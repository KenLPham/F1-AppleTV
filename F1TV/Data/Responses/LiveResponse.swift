//
//  LiveResponse.swift
//  F1TV
//
//  Created by Ken Pham on 7/2/20.
//  Copyright © 2020 Phez Technologies. All rights reserved.
//

import Foundation

struct LiveResponse: Decodable {
	let objects: [LiveObject]
}

struct LiveObject: Decodable {
	let items: [LiveItem]
}

struct LiveItem: Decodable, Identifiable {
	enum CodingKeys: String, CodingKey {
		case content = "content_url", id = "uid", position
	}
	
	let content: String
	let id: String
	let position: Int
}
