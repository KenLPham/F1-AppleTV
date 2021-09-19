//
//  ObservableObject+F1TV.swift
//  F1TV
//
//  Created by Kenneth Pham on 6/13/21.
//  Copyright © 2021 Phez Technologies. All rights reserved.
//

import SwiftUI
import os.log

extension ObservableObject {
    public var className: String {
        String(describing: type(of: self))
    }
    
    func handleErrors (_ error: Lite.Errors) {
        Logger.apiClient.error("[\(self.className)] \(String(describing: error))")
    }
}
