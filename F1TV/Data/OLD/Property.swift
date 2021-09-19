//
//  Property.swift
//  F1TV
//
//  Created by Kenneth Pham on 6/12/21.
//  Copyright © 2021 Phez Technologies. All rights reserved.
//

import Foundation

struct Property: Decodable {
    let meetingNumber: Int
    let sessionEndTime: Int
    let series: String
    let lastUpdatedDate: Int
    let seasonMeetingOrdinal: Int
    let meetingStartDate: Int
    let meetingEndDate: Int
    let season: Int
    let sessionIndex: Int
    let sessionStartDate: Int?
    let meetingSessionKey: Int?
    let sessionEndDate: Int?
}

extension Property {
    enum CodingKeys: String, CodingKey {
        case meetingNumber = "meeting_Number",
             sessionEndTime = "sessionEndTime",
             series,
             lastUpdatedDate,
             seasonMeetingOrdinal = "season_Meeting_Ordinal",
             meetingStartDate = "meeting_Start_Date",
             meetingEndDate = "meeting_End_Date",
             season,
             sessionIndex = "session_index",
             sessionStartDate,
             meetingSessionKey,
             sessionEndDate
    }
}
