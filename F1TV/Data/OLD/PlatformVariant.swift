//
//  PlatformVariant.swift
//  F1TV
//
//  Created by Kenneth Pham on 6/12/21.
//  Copyright © 2021 Phez Technologies. All rights reserved.
//

import Foundation

struct PlatformVariant: Decodable {
//    let subtitlesLanguages: [Any]
//    let audioLanguages: [Any]
    let technicalPackages: [TechnicalPackage]
    let cpId: Int?
    let videoType: String?
    let pictureUrl: String?
    let trailerUrl: String?
    let hasTrailer: Bool?
}
