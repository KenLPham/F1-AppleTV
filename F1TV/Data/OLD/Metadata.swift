//
//  Metadata.swift
//  F1TV
//
//  Created by Kenneth Pham on 6/12/21.
//  Copyright © 2021 Phez Technologies. All rights reserved.
//

import Foundation

struct Metadata: Decodable, Identifiable {
    let id = UUID()
    
    let attributes: EmfAttributes?
    let longDescription: String?
    let country: String?
    let year: String?
    let contractStartDate: Int?
    let episodeNumber: Int?
    let contractEndDate: Int?
    let externalId: String?
    let title: String?
    let titleBrief: String?
    let objectType: String?
    let duration: Int?
    let genres: [String]?
    let contentSubtype: ContentSubtype?
    let pcLevel: Int?
    let contentId: Int?
    let starRating: Int?
    let pictureUrl: String?
    let contentType: ContentType?
    let language: String?
    let season: Int?
    let uiDuration: String?
    let entitlement: String?
    let locked: Bool?
    let label: String?
    let imageUrl: String?
    let metaDescription: String?
    let isADVAllowed: Bool?
    let contentProvider: String?
    let isLatest: Bool?
    let isOnAir: Bool?
    let isEncrypted: Bool?
    let objectSubtype: String?
    let metadataLanguage: String?
    let pcLevelVod: String?
    let isParent: Bool?
    let availableLanguages: [AvailableLanguage]?
    let advTags: String?
    let shortDescription: String?
    let leavingSoon: Bool?
    let availableAlso: [String]?
    let pcVodLabel: String?
    let isGeoBlocked: Bool?
    let filter: String?
//    let comingSoon: String? (bool for ContentContainer)
    let isPopularEpisode: Bool?
    let primaryCategoryId: Int?
    let meetingKey: String?
    let videoType: String?
    let parentalAdvisory: String?
    let additionalStreams: [AdditionalStream]?
}

extension Metadata {
    enum CodingKeys: String, CodingKey {
        case attributes = "emfAttributes",
             longDescription,
             country,
             year,
             contractStartDate,
             episodeNumber,
             contractEndDate,
             externalId,
             title,
             titleBrief,
             objectType,
             duration,
             genres,
             contentSubtype,
             pcLevel,
             contentId,
             starRating,
             pictureUrl,
             contentType,
             language,
             season,
             uiDuration,
             entitlement,
             locked,
             label,
             imageUrl,
             metaDescription = "meta-description",
             isADVAllowed,
             contentProvider,
             isLatest,
             isOnAir,
             isEncrypted,
             objectSubtype,
             metadataLanguage,
             pcLevelVod,
             isParent,
             availableLanguages,
             advTags,
             shortDescription,
             leavingSoon,
             availableAlso,
             pcVodLabel,
             isGeoBlocked,
             filter,
//             comingSoon,
             isPopularEpisode,
             primaryCategoryId,
             meetingKey,
             videoType,
             parentalAdvisory,
             additionalStreams
    }
}
