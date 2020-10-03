//
//  LiveResponse.swift
//  F1TV
//
//  Created by Ken Pham on 7/2/20.
//  Copyright © 2020 Phez Technologies. All rights reserved.
//

import Foundation

public struct LiveResponse: Decodable {
	public let objects: [LiveObject]
}

public struct LiveObject: Decodable {
	public let items: [LiveItem]
}

public struct LiveItem: Decodable, Identifiable {
	enum CodingKeys: String, CodingKey {
		case content = "content_url", id = "uid", position
	}
	
    public let content: String
    public let id: String
    public let position: Int
}
