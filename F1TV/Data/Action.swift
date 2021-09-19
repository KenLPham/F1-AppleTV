//
//  Action.swift
//  F1TV
//
//  Created by Kenneth Pham on 6/12/21.
//  Copyright © 2021 Phez Technologies. All rights reserved.
//

import Foundation

struct Action: Decodable {
    let key: String
    let uri: String
    /// Target type is mostly useless (seems to always be `DETAILS_PAGE` when in `ContentContainer`
    /// `WALL_PAGE` is another value but for the `ResultContainer`
    let targetType: String
    let type: String?
    let layout: String?
}
