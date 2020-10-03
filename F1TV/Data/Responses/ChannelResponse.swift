//
//  ChannelResponse.swift
//  F1TV
//
//  Created by Ken Pham on 7/2/20.
//  Copyright © 2020 Phez Technologies. All rights reserved.
//

import Foundation

public struct ChannelResponse: Decodable, Identifiable {
	enum CodingKeys: String, CodingKey {
		case driver = "driveroccurrence_urls", id = "uid", type = "channel_type", name, key = "self"
	}
	
	/**
	Path to driver information.
	Example: /api/driver-occurrence/driv_9fc9eea9818f4f5fa88fa3daf5969732/
	*/
	let driver: [String]
	let id: String
	let type: String // driver, other (driver, pit lane, data), wif (main feed?)
	let name: String
	/**
	channel_url used to generate stream URL
	Example: /api/channels/chan_f4305e0c5c2e4413a8d5e3e12d9628b8/
	*/
	let key: String
}
