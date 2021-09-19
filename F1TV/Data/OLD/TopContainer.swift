//
//  TopContainer.swift
//  F1TV
//
//  Created by Kenneth Pham on 6/12/21.
//  Copyright © 2021 Phez Technologies. All rights reserved.
//

import Foundation

struct TopContainer: Decodable, Identifiable {
    let id = UUID()
    
    let layout: Layout
    let actions: [Action]
    let metadata: Metadata
    let retrieveItems: RetrieveItems
    let translations: Translations?
    
    /// Only in content details
//    let platformVariants: [PlatformVariant]?
//    let contentId: Int?
//    let containers: [ContentContainer<String>.Container]?
//    let suggest: Suggest?
//    let platformName: String?
//    let properties: [Property]?
}

extension TopContainer {
    enum CodingKeys: String, CodingKey {
        case layout,
             actions,
             metadata,
             retrieveItems,
             translations
//             platformVariants,
//             contentId,
//             containers,
//             suggest,
//             platformName,
//             properties
    }
    
    enum Layout: String, Decodable {
        case hero, horizontal = "horizontal_thumbnail", vertical = "vertical_thumbnail"
    }
}
