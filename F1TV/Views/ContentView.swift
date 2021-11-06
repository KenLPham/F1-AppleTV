//
//  ContentView.swift
//  F1TV
//
//  Created by Kenneth Pham on 6/12/21.
//  Copyright © 2021 Phez Technologies. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = ContentViewModel()
    
    var body: some View {
        VStack {
            // - TODO: Wrap PageView so that it is always visible (except in videos)
            if let containers = viewModel.menuContainers {
                MenuView(containers: containers, viewModel: viewModel)
            }
            PageView(viewModel: viewModel)
        }.onAppear(perform: viewModel.load)
        // - TODO: on enter foreground reload data
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
