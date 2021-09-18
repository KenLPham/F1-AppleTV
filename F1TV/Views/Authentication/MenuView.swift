//
//  MenuView.swift
//  F1TV
//
//  Created by Ken Pham on 7/2/20.
//  Copyright © 2020 Phez Technologies. All rights reserved.
//

import SwiftUI
import Combine

struct MenuView: View {
    @Environment(\.appState) var appState
	@Environment(\.authorized) var authorize
    @StateObject var state = ViewState()
	
    var body: some View {
        
		TabView {
            
            if let response = state.live {
                LiveView(live: response)
                    .tabItem { Label("Race Weekend", systemImage: "video.fill") }
            }
            
            SeasonsView()
                .tabItem { Label("Archive", systemImage: "archivebox.fill") }
            
            Button("Signout", action: signout)
                .tabItem { Label("Signout", systemImage: "person.crop.circle.badge.minus") }
            
        }.navigationBarTitle("F1TV")/*.navigationBarItems(leading: Button("Signout", action: signout))*/.onAppear(perform: state.load)
        
    }
	
	private func signout () {
		authorize.store(nil)
        appState.option = .notAuthorized
	}
}

extension MenuView {
    class ViewState: ObservableObject {
        @Environment(\.apiClient) var skylark
        @Published var live: LiveResponse?
        
        var cancellables = [AnyCancellable]()
        
        func load () {
            skylark.getLive().receive(on: DispatchQueue.main).sink {
                switch $0 {
                case .failure(let error):
                    switch error {
                    case .unauthorized:
                        print("show unauthed alert")
                    default:
                        print("authenticate:", String(describing: error))
                    }
                case .finished: ()
                }
            } receiveValue: {
                self.live = $0
            }.store(in: &cancellables)
        }
    }
}
