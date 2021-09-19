//
//  Lazy.swift
//  F1TV
//
//  Created by Kenneth Pham on 6/12/21.
//  Copyright © 2021 Phez Technologies. All rights reserved.
//

import SwiftUI

struct Lazy<Content: View>: View {
    var content: () -> Content
    
    init (_ content: @autoclosure @escaping () -> Content) {
        self.content = content
    }
    
    var body: Content {
        content()
    }
}
