//
//  EventResponse.swift
//  F1TV
//
//  Created by Ken Pham on 7/2/20.
//  Copyright © 2020 Phez Technologies. All rights reserved.
//

import Foundation

public struct EventResponse: Decodable, Identifiable {
	enum CodingKeys: String, CodingKey {
		case images = "image_urls", sessions = "sessionoccurrence_urls", id = "uid", name, officialName = "official_name", startDate = "start_date"
	}
	
    public let images: [String]
    public let sessions: [String]
    public let id: String
    public let name: String
    public let officialName: String
    public let startDate: String
	
	func date () -> Date {
		DateFormatter.dependecy().formatShort(startDate)!
	}
}

// MARK: - Date Extension
extension DateFormatter {
	static var dependecy: () -> DateFormatter = DateFormatter.init
	
	func formatShort (_ string: String) -> Date? {
		self.dateFormat = "yyyy-MM-dd"
		return self.date(from: string)
	}
}
