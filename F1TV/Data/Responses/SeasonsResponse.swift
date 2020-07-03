//
//  SeasonsResponse.swift
//  F1TV
//
//  Created by Ken Pham on 7/2/20.
//  Copyright © 2020 Phez Technologies. All rights reserved.
//

import Foundation

struct SeasonsResponse: Decodable {
	let objects: [RaceSeason]
}

struct RaceSeason: Decodable, Identifiable {
	enum CodingKeys: String, CodingKey {
		case schedule = "schedule_urls", events = "eventoccurrence_urls", id = "uid", hasContent = "has_content", name
	}
	
	let schedule: [String]
	let events: [String]
	let id: String
	let hasContent: Bool
	let name: String
}
