//
//  Suggest.swift
//  F1TV
//
//  Created by Kenneth Pham on 6/12/21.
//  Copyright © 2021 Phez Technologies. All rights reserved.
//

import Foundation

struct Suggest: Decodable {
    let input: [String]
    let payload: Payload
}

extension Suggest {
    struct Payload: Decodable {
        let objectSubtype: String
        let contentId: String
        let title: String
        let objectType: String
    }
}
