//
//  EmfAttributes.swift
//  F1TV
//
//  Created by Kenneth Pham on 6/12/21.
//  Copyright © 2021 Phez Technologies. All rights reserved.
//

import Foundation

struct EmfAttributes: Decodable {
    let videoType: String?
    let meetingKey: String
    let meetingSessionKey: String
    let meetingName: String
    let meetingNumber: String
    let circuitShortName: String
    let meetingCode: String
    let meetingCountryKey: String
    let circuitKey: String
    let meetingLocation: String
    let series: String
    let obc: Bool
    let state: String?
    let timetableKey: String?
    let sessionKey: String?
    let sessionPeriod: String?
    let circuitOfficialName: String?
    let activityDescription: String?
    let seriesMeetingSessionIdentifier: String?
    let sessionEndTime: String
    let meetingStartDate: String?
    let meetingEndDate: String?
    let trackLength: String?
    let scheduledLapCount: String?
    let scheduledDistance: String?
    let circuitLocation: String?
    let meetingSponsor: String?
    let isTestEvent: String?
    let championshipMeetingOrdinal: String?
    let meetingOfficialName: String?
    let meetingDisplayDate: String?
//    let pageId: Any
    let meetingCountryName: String
    let globalTitle: String
    let globalMeetingCountryName: String
    let globalMeetingName: String
    let driversId: String?
    let year: String?
    let teamsId: String?
    
    // inconsistent types
//    let seasonMeetingOrdinal: Int | Season_Meeting_Ordinal
//    let sessionStartDate: Int | sessionStartDate
//    let sessionEndDate: Int | sessionEndDate
//    let sessionIndex: Int | session_index
    
    var countryFlag: URL? {
        URL(string: "https://ott-img.formula1.com/countries/\(meetingCountryKey).png")
    }
}

extension EmfAttributes {
    enum CodingKeys: String, CodingKey {
        case videoType = "VideoType",
             meetingKey = "MeetingKey",
             meetingSessionKey = "MeetingSessionKey",
             meetingName = "Meeting_Name",
             meetingNumber = "Meeting_Number",
             circuitShortName = "Circuit_Short_Name",
             meetingCode = "Meeting_Code",
             meetingCountryKey = "MeetingCountryKey",
             circuitKey = "CircuitKey",
             meetingLocation = "Meeting_Location",
             series = "Series",
             obc = "OBC",
             state,
             timetableKey = "TimetableKey",
             sessionKey = "SessionKey",
             sessionPeriod = "SessionPeriod",
             circuitOfficialName = "Circuit_Official_Name",
             activityDescription = "ActivityDescription",
             seriesMeetingSessionIdentifier = "SeriesMeetingSessionIdentifier",
             sessionEndTime = "sessionEndTime",
             meetingStartDate = "Meeting_Start_Date",
             meetingEndDate = "Meeting_End_Date",
             trackLength = "Track_Length",
             scheduledLapCount = "Scheduled_Lap_Count",
             scheduledDistance = "Scheduled_Distance",
             circuitLocation = "Circuit_Location",
             meetingSponsor = "Meeting_Sponsor",
             isTestEvent = "IsTestEvent",
             championshipMeetingOrdinal = "Championship_Meeting_Ordinal",
             meetingOfficialName = "Meeting_Official_Name",
             meetingDisplayDate = "Meeting_Display_Date",
             meetingCountryName = "Meeting_Country_Name",
             globalTitle = "Global_Title",
             globalMeetingCountryName = "Global_Meeting_Country_Name",
             globalMeetingName = "Global_Meeting_Name",
             driversId = "Drivers_ID",
             year = "Year",
             teamsId = "Teams_ID"
    }
}

