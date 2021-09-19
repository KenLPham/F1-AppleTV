//
//  Category.swift
//  F1TV
//
//  Created by Kenneth Pham on 6/12/21.
//  Copyright © 2021 Phez Technologies. All rights reserved.
//

import Foundation

struct Category: Decodable {
    let externalPathIds: [String]
    let startDate: Int
    let categoryId: Int
    let endDate: Int
    let categoryPathIds: [Int]
    let orderId: Int
    let isPrimary: Bool?
    let categoryName: String?
}
