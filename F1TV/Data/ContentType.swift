//
//  ContentType.swift
//  F1TV
//
//  Created by Kenneth Pham on 6/13/21.
//  Copyright © 2021 Phez Technologies. All rights reserved.
//

import Foundation

enum ContentType: String, Decodable {
    case video = "VIDEO",
         bundle = "BUNDLE",
         launcher = "LAUNCHER"
}

enum ContentSubtype: String, Decodable {
    case live = "LIVE",
         replay = "REPLAY",
         feature = "FEATURE",
         extendedHighlights = "EXTENDED HIGHLIGHTS",
         analysis = "ANALYSIS",
         raceHighlights = "RACE HIGHLIGHTS",
         pressConference = "PRESS CONFERENCE",
         highlights = "HIGHLIGHTS",
         show = "SHOW",
         documentary = "DOCUMENTARY",
         meeting = "MEETING",
         launcher = "LAUNCHER"
}
