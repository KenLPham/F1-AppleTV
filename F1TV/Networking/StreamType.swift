//
//  StreamType.swift
//  F1TV
//
//  Created by Kenneth Pham on 6/12/21.
//  Copyright © 2021 Phez Technologies. All rights reserved.
//

import Foundation

enum StreamType: String {
    case bigScreen = "BIG_SCREEN_",
         web = "WEB_",
         tablet = "TABLET_",
         mobile = "MOBILE_"
}

extension StreamType {
    var hls: String {
        self.rawValue + "HLS"
    }
    
    var dash: String {
        self.rawValue + "DASH"
    }
}
