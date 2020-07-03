//
//  SessionResponse.swift
//  F1TV
//
//  Created by Ken Pham on 7/2/20.
//  Copyright © 2020 Phez Technologies. All rights reserved.
//

import Foundation

struct SessionResponse: Decodable, Identifiable {
	enum CodingKeys: String, CodingKey {
		case images = "image_urls", status, id = "uid", name, sessionName = "session_name", startTime = "start_time", channels = "channel_urls", series = "series_url"
	}
	
	let images: [String]
	let status: String
	let id: String
	let name: String
	let sessionName: String
	let startTime: Date
	let channels: [String]
	let series: String?
	
	@available(*, deprecated, message: "Find a better way to only show F1 sessions in event call instead of checking after the fact")
	var isF1: Bool {
		series == "/api/series/seri_436bb431c3a24d7d8e200a74e1d11de4/" || series == nil
	}
}
