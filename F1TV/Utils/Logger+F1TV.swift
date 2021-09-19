//
//  Logger+F1TV.swift
//  F1TV
//
//  Created by Kenneth Pham on 6/12/21.
//  Copyright © 2021 Phez Technologies. All rights reserved.
//

import Foundation
import os.log

extension Logger {
    static var bundleIdentifier = Bundle.main.bundleIdentifier!
    
    static var apiClient = Logger(subsystem: bundleIdentifier, category: "APIClient")
    static var auth = Logger(subsystem: bundleIdentifier, category: "AuthHandler")
    static var client = Logger(subsystem: bundleIdentifier, category: "App")
    static var image = Logger(subsystem: bundleIdentifier, category: "Image Client")
}
