//
//  ContentMetadata.swift
//  F1TV
//
//  Created by Kenneth Pham on 6/13/21.
//  Copyright © 2021 Phez Technologies. All rights reserved.
//

import Foundation

struct ContentMetadata: Decodable {
    let attributes: EmfAttributes?
    let longDescription: String
    let year: String
    let title: String
    let titleBrief: String
    let duration: Int
    let genres: [String]
    let contentSubtype: ContentSubtype
//    let contentId: Int
//    let starRating: Int
    let pictureUrl: String
    let contentType: ContentType
//    let season: Int
    let uiDuration: String
    let additionalStreams: [AdditionalStream]?
}

extension ContentMetadata {
    enum CodingKeys: String, CodingKey {
        case attributes = "emfAttributes",
             longDescription,
             year,
             title,
             titleBrief,
             duration,
             genres,
             contentSubtype,
//             contentId,
//             starRating,
             pictureUrl,
             contentType,
//             season,
             uiDuration,
             additionalStreams
    }
}
