//
//  ScheduleContainer.swift
//  F1TV
//
//  Created by Ken Pham on 7/3/21.
//  Copyright © 2021 Phez Technologies. All rights reserved.
//

import Foundation

/// - TODO: finish this
// https://f1tv.formula1.com/2.0/R/ENG/BIG_SCREEN_HLS/ALL/PAGE/395/F1_TV_Pro_Annual/2
struct ScheduleContainer: Decodable {
    let eventName: String
    let events: [Event]
}

extension ScheduleContainer: Identifiable {
    var id: String {
        self.eventName
    }
}

extension ScheduleContainer {
    struct Event: Decodable, Identifiable {
        let id: String
        let layout: String // CONTENT_ITEM
        let actions: [Action]
        let metadata: ScheduleMetadata
    }
}
