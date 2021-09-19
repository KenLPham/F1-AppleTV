//
//  ContentContainer.swift
//  F1TV
//
//  Created by Kenneth Pham on 6/13/21.
//  Copyright © 2021 Phez Technologies. All rights reserved.
//

import Foundation
import CoreGraphics

struct ContentContainer<ID>: Decodable, Identifiable where ID: Hashable, ID: Decodable {
    let id: ID
    let layout: String?
    let actions: [Action]?
    let metadata: ContentMetadata
}

extension ContentContainer {
    var isRace: Bool {
        metadata.contentSubtype == .live || metadata.contentSubtype == .replay
    }
    
    func pictureUrl (width: CGFloat, height: CGFloat) -> URL? {
        return URL(string: "https://ott.formula1.com/image-resizer/image/\(metadata.pictureUrl)?w=\(width)&h=\(height)&q=HI&o=L")
    }
}
