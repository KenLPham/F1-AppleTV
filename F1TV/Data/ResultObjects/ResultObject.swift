//
//  ResultObject.swift
//  F1TV
//
//  Created by Kenneth Pham on 6/12/21.
//  Copyright © 2021 Phez Technologies. All rights reserved.
//

import Foundation

struct ResultObject<C: Decodable>: Decodable {
    let total: Int
    let containers: [C]
    let meetingName: String?
}
