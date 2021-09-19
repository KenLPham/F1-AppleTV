//
//  MenuView.swift
//  F1TV
//
//  Created by Kenneth Pham on 6/13/21.
//  Copyright © 2021 Phez Technologies. All rights reserved.
//

import SwiftUI

struct MenuView<ViewModel: MenuViewModel>: View {
    @Environment(\.authorized) var authorize
    
    let containers: [MenuContainer]
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        HStack {
            Image("Logo")
            ForEach(containers) { container in
                if let label = container.metadata.label {
                    MenuButton(label) {
                        viewModel.loadPage(container)
                    }
                }
            }
            Spacer()
            MenuButton("Sign Out", action: authorize.signOut)
        }.padding().background(Color.primaryColor.cornerRadius(8))
    }
}

struct MenuButton: View {
    let label: String
    let action: () -> ()
    
    init (_ label: String, action: @escaping () -> ()) {
        self.label = label
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            Text(label).padding()
        }.buttonStyle(PlainButtonStyle())
    }
}
