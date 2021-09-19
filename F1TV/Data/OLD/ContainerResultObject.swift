//
//  ContainerResultObject.swift
//  F1TV
//
//  Created by Kenneth Pham on 6/12/21.
//  Copyright © 2021 Phez Technologies. All rights reserved.
//

import Foundation

struct ContainerResultObject: Decodable {
    let total: Int?
    let containers: [ContentContainer<String>]?
    let meetingName: String?
    let metadata: Metadata?
}
