//
//  APIResponse.swift
//  F1TV
//
//  Created by Kenneth Pham on 6/12/21.
//  Copyright © 2021 Phez Technologies. All rights reserved.
//

import Foundation

struct APIResponse<R: Decodable>: Decodable {
    let resultCode: String
    let message: String
    let errorDescription: String
    let resultObj: R
    let systemTime: Int
    let source: String?
}
