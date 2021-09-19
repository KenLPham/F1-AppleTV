//
//  AdditionalStreamButton.swift
//  F1TV
//
//  Created by Ken Pham on 6/27/21.
//  Copyright © 2021 Phez Technologies. All rights reserved.
//

import SwiftUI

struct AdditionalStreamButton: View {
    var stream: AdditionalStream
    var selected: (AdditionalStream) -> ()
    
    var body: some View {
        Button(action: {
            self.selected(stream)
        }) {
            HStack(spacing: 10) {
                if stream.type == .driver {
                    Text("\(stream.racingNumber)").fixedSize()
                    if let hexString = stream.color, let color = Color(hex: hexString) {
                        Rectangle().fill(color).frame(width: 10, height: 30)
                    }
                }
                Text(stream.title).fixedSize()
            }
        }
    }
}

struct AdditionalStreamButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            AdditionalStreamButton(stream: AdditionalStream(racingNumber: 5, title: "VET", driverFirstName: "Sebastian", driverLastName: "Vettel", teamName: "Aston Martin", constructorName: "Aston Martin", type: .driver, playbackUrl: "CONTENT/PLAY?channelId=1018&contentId=1000004307", driverImage: "", teamImage: "", color: "#006F62"), selected: { _ in })
        }.padding().previewLayout(.sizeThatFits)
    }
}
