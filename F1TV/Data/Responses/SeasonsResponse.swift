//
//  SeasonsResponse.swift
//  F1TV
//
//  Created by Ken Pham on 7/2/20.
//  Copyright © 2020 Phez Technologies. All rights reserved.
//

import Foundation

public struct SeasonsResponse: Decodable {
    public let objects: [RaceSeason]
}

public struct RaceSeason: Decodable, Identifiable {
	enum CodingKeys: String, CodingKey {
		case schedule = "schedule_urls", events = "eventoccurrence_urls", id = "uid", hasContent = "has_content", name
	}
	
    public let schedule: [String]
    public let events: [String]
    public let id: String
    public let hasContent: Bool
    public let name: String
}
