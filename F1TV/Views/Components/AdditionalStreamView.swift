//
//  AdditionalStreamView.swift
//  F1TV
//
//  Created by Ken Pham on 6/27/21.
//  Copyright © 2021 Phez Technologies. All rights reserved.
//

import SwiftUI

struct AdditionalStreamView: View {
    @ObservedObject var viewModel: StreamViewModel
    
    var circuitStreams: [AdditionalStream]? {
        viewModel.channels?.metadata.additionalStreams?.filter { $0.type == .circuit }
    }
    
    var driverStreams: [AdditionalStream]? {
        viewModel.channels?.metadata.additionalStreams?.filter { $0.type == .driver }
    }
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                Section(header: EmptyView()) {
                    Button(action: viewModel.load) {
                        Text("MAIN").fixedSize()
                    }
                    if let streams = self.circuitStreams {
                        ForEach(streams) { stream in
                            AdditionalStreamButton(stream: stream, selected: viewModel.loadStream)
                        }
                    }
                }
                if let streams = self.driverStreams {
                    Section(header: Text("Drivers")) {
                        ForEach(streams) { stream in
                            AdditionalStreamButton(stream: stream, selected: viewModel.loadStream)
                        }
                    }
                }
            }.padding()
        }.frame(width: UIScreen.main.bounds.insetBy(dx: 80, dy: 0).width)
    }
}
