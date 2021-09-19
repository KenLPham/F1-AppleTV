//
//  ScheduleMetadata.swift
//  F1TV
//
//  Created by Ken Pham on 8/27/21.
//  Copyright © 2021 Phez Technologies. All rights reserved.
//

import Foundation

struct ScheduleMetadata: Decodable {
    let attributes: Attributes
    let longDescription: String
}

extension ScheduleMetadata {
    enum CodingKeys: String, CodingKey {
        case attributes = "emfAttributes",
             longDescription
    }
    
    struct Attributes: Decodable {
        let sessionEndDate: Date
        let sessionStartDate: Date
    }
}
