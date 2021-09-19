//
//  TechnicalPackage.swift
//  F1TV
//
//  Created by Kenneth Pham on 6/12/21.
//  Copyright © 2021 Phez Technologies. All rights reserved.
//

import Foundation

struct TechnicalPackage: Decodable, Identifiable {
    let id = UUID()
    
    let name: String?
    let type: String
}

extension TechnicalPackage {
    enum CodingKeys: String, CodingKey {
        case name = "packageName",
             type = "packageType"
    }
}
