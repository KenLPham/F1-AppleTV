//
//  AdditionalStream.swift
//  F1TV
//
//  Created by Kenneth Pham on 6/12/21.
//  Copyright © 2021 Phez Technologies. All rights reserved.
//

import Foundation

struct AdditionalStream: Decodable {
    let racingNumber: Int
    let title: String
    let driverFirstName: String?
    let driverLastName: String?
    let teamName: String
    let constructorName: String?
    let type: CameraType
    let playbackUrl: String
    let driverImage: String
    let teamImage: String
    let color: String?
    
    var trackName: String {
        switch self.title {
        case "PIT LANE":
            return "Pit Lane"
        case "TRACKER":
            return "Driver Tracker"
        case "DATA":
            return "Data Channel"
        default:
            return self.driverFirstName! + " " + self.driverLastName!
        }
    }
}

extension AdditionalStream: Identifiable {
    enum CodingKeys: String, CodingKey {
        case racingNumber,
             title,
             driverFirstName,
             driverLastName,
             teamName,
             constructorName,
             type,
             playbackUrl,
             driverImage = "driverImg",
             teamImage = "teamImg",
             color = "hex"
    }
    
    enum CameraType: String, Decodable {
        case circuit = "additional", driver = "obc"
    }
    
    var id: String {
        self.playbackUrl
    }
}
