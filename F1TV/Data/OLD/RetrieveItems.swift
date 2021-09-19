//
//  RetrieveItems.swift
//  F1TV
//
//  Created by Kenneth Pham on 6/12/21.
//  Copyright © 2021 Phez Technologies. All rights reserved.
//

import Foundation

struct RetrieveItems: Decodable {
    let resultObj: ContainerResultObject?
    let uriOriginal: String?
    let typeOriginal: String?
}
