//
//  LiteBundle.swift
//  F1TV
//
//  Created by Kenneth Pham on 6/12/21.
//  Copyright © 2021 Phez Technologies. All rights reserved.
//

import Foundation

struct LiteBundle: Decodable, Identifiable {
    let id: Int
    let type: String
    let subtype: String
    let isParent: Bool
    let orderId: Int
}

extension LiteBundle {
    enum CodingKeys: String, CodingKey {
        case id = "bundleId",
             type = "bundleType",
             subtype = "bundleSubtype",
             isParent,
             orderId
    }
}
