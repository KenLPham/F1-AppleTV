//
//  PageContainer.swift
//  F1TV
//
//  Created by Kenneth Pham on 6/13/21.
//  Copyright © 2021 Phez Technologies. All rights reserved.
//

import Foundation
import os

struct PageContainer: Decodable, Identifiable {
    let id: String
    let layout: Layout
    let retrieveItems: RetrieveItems
    let metadata: ContainerMetadata
    
    init (from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.layout = try container.decode(Layout.self, forKey: .layout)
        do {
            self.retrieveItems = try container.decode(RetrieveItems.self, forKey: .retrieveItems)
        } catch {
            Logger.apiClient.error("Failed to decode container \(String(describing: error))")
            self.retrieveItems = RetrieveItems(resultObject: ResultObject(containers: nil, schedules: nil))
        }
        self.metadata = try container.decode(ContainerMetadata.self, forKey: .metadata)
    }
}

extension PageContainer {
    enum CodingKeys: String, CodingKey {
        case id, layout, retrieveItems, metadata
    }
    
    enum Layout: String, Decodable {
        case hero, horizontal = "horizontal_thumbnail", vertical = "vertical_thumbnail", title, subtitle, gpBanner = "gp_banner", schedule
    }
    
    struct RetrieveItems: Decodable {
        let resultObject: ResultObject
    }
    
    struct ResultObject: Decodable {
        let containers: [ContentContainer<String>]?
        let schedules: [ScheduleContainer]?
        
        init (containers: [ContentContainer<String>]?, schedules: [ScheduleContainer]?) {
            self.containers = containers
            self.schedules = schedules
        }
        
        init (from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            do {
                self.containers = try container.decode([ContentContainer<String>].self, forKey: .containers)
                self.schedules = nil
            } catch {
                self.containers = nil
                self.schedules = try container.decode([ScheduleContainer].self, forKey: .containers)
            }
        }
        
        var currentSchedules: [ScheduleContainer]? {
            schedules?.filter { !$0.events.isEmpty }
        }
    }
}

extension PageContainer.ResultObject {
    enum CodingKeys: String, CodingKey {
        case containers
    }
}

extension PageContainer.RetrieveItems {
    enum CodingKeys: String, CodingKey {
        case resultObject = "resultObj"
    }
}
