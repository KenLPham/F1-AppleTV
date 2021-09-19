//
//  VideoItemView.swift
//  F1TV
//
//  Created by Kenneth Pham on 6/13/21.
//  Copyright © 2021 Phez Technologies. All rights reserved.
//

import SwiftUI

protocol VideoItemView: View {
    var item: ContentContainer<String> { get }
    
    init (item: ContentContainer<String>)
}
