//
//  MenuContainer.swift
//  F1TV
//
//  Created by Kenneth Pham on 6/13/21.
//  Copyright © 2021 Phez Technologies. All rights reserved.
//

import Foundation

struct MenuContainer: Decodable, Identifiable {
    let id: String
    let actions: [Action]
    let metadata: ContainerMetadata
}
