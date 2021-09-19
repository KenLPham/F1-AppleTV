//
//  ScheduleView.swift
//  F1TV
//
//  Created by Ken Pham on 8/27/21.
//  Copyright © 2021 Phez Technologies. All rights reserved.
//

import SwiftUI

struct ScheduleView: View {
    @State var selectedSchedule: ScheduleContainer?
    
    let container: PageContainer

    @ViewBuilder
    var body: some View {
        if let schedules = container.retrieveItems.resultObject.currentSchedules {
            VStack(alignment: .leading) {
                Text("Weekend Schedule".uppercased()).font(.title2)
                if let selectedSchedule = self.selectedSchedule {
                    VStack(alignment: .leading, spacing: 5) {
                        ForEach(selectedSchedule.events.sorted(by: {
                            $0.metadata.attributes.sessionStartDate < $1.metadata.attributes.sessionStartDate
                        })) { event in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(event.metadata.longDescription.uppercased())
                                }
                                Spacer()
                                VStack(alignment: .trailing) {
                                    let startDate = event.metadata.attributes.sessionStartDate
                                    let endDate = event.metadata.attributes.sessionEndDate
                                    Text(DateIntervalFormatter.eventDateFormatter.string(from: startDate, to: endDate))
                                }
                            }
                        }
                    }
                }
                // only show buttons if more than one schedule is available
                if !(schedules.count == 2 && schedules.contains(where: { $0.eventName.lowercased() == "all" })) {
                    HStack {
                        ForEach(schedules) { schedule in
                            Button(action: {
                                self.selectedSchedule = schedule
                            }) {
                                Text(schedule.eventName).padding()
                            }.buttonStyle(.plain)
                        }
                    }
                }
            }.padding().onAppear {
                if self.selectedSchedule == nil {
                    self.selectedSchedule = schedules.first
                }
            }
        }
    }
}

extension DateIntervalFormatter {
    static let eventDateFormatter: DateIntervalFormatter = {
        let dateFormatter = DateIntervalFormatter()
        dateFormatter.dateTemplate = "EE HH:mm"
        
        return dateFormatter
    }()
}
