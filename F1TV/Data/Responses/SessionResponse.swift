//
//  SessionResponse.swift
//  F1TV
//
//  Created by Ken Pham on 7/2/20.
//  Copyright © 2020 Phez Technologies. All rights reserved.
//

import Foundation

public struct SessionResponse: Decodable, Identifiable {
	enum CodingKeys: String, CodingKey {
		case images = "image_urls", status, id = "uid", name, sessionName = "session_name", startTime = "start_time", channels = "channel_urls", series = "series_url"
	}
	
    public let images: [String]
    public let status: String // live or replay
    public let id: String
    public let name: String
    public let sessionName: String
    public let startTime: Date
    public let channels: [String]
    public let series: String?
	
	@available(*, deprecated, message: "Find a better way to only show F1 sessions in event call instead of checking after the fact")
	var isF1: Bool {
		self.series == "/api/series/seri_436bb431c3a24d7d8e200a74e1d11de4/" || self.series == nil
	}
	
	var isLive: Bool {
		self.status == "live"
	}
}
