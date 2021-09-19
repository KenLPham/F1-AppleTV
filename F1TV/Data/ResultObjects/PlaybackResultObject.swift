//
//  PlaybackResultObject.swift
//  F1TV
//
//  Created by Kenneth Pham on 6/13/21.
//  Copyright © 2021 Phez Technologies. All rights reserved.
//

import Foundation

struct PlaybackResultObject: Decodable {
    let entitlementToken: String
    let url: URL
    let streamType: String
}
