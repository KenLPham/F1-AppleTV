//
//  EventLink.swift
//  F1TV
//
//  Created by Kenneth Pham on 10/3/20.
//  Copyright © 2020 Phez Technologies. All rights reserved.
//

import SwiftUI

struct EventLink: View {
    var event: EventResponse
    
    var body: some View {
        NavigationLink(destination: Lazy(EventView(event: event))) {
            Text(event.name).bold().font(.title2)
            Text(event.officialName).font(.subheadline).foregroundColor(Color(.secondaryLabel))
        }
    }
}
