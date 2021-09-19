//
//  Translations.swift
//  F1TV
//
//  Created by Kenneth Pham on 6/12/21.
//  Copyright © 2021 Phez Technologies. All rights reserved.
//

import Foundation

struct Translations: Decodable {
    let label: Label
}

extension Translations {
    enum CodingKeys: String, CodingKey {
        case label = "metadata.label"
    }
    
    struct Label: Decodable {
        let nld: String?
        let fra: String?
        let deu: String?
        let por: String?
        let spa: String?
    }
}

extension Translations.Label {
    enum CodingKeys: String, CodingKey {
        case nld = "NLD",
             fra = "FRA",
             deu = "DEU",
             por = "POR",
             spa = "SPA"
    }
}
