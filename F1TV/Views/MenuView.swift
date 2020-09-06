//
//  MenuView.swift
//  F1TV
//
//  Created by Ken Pham on 7/2/20.
//  Copyright © 2020 Phez Technologies. All rights reserved.
//

import SwiftUI

struct SignoutButton: View {
	var action: () -> ()
	
	var body: some View {
		Button(action: action) {
			Text("Signout")
		}
	}
}

struct MenuView: View {
	@Environment(\.presentationMode) var presentation
	@Environment(\.authorized) var authorize
	
	@State var live: LiveResponse?
	
    var body: some View {
		VStack {
			NavigationLink(destination: Lazy(SeasonsView())) {
				Text("Archive")
			}
			Optional($live.wrappedValue) { response in
				NavigationLink(destination: Lazy(LiveView(live: response))) {
					Text("Race Weekend")
				}
			}
		}.navigationBarTitle("F1TV").navigationBarItems(trailing: SignoutButton(action: signout)).onAppear(perform: load)
    }
	
	private func load () {
		Skylark.shared.getLive { result in
			switch result {
			case .success(let response):
				DispatchQueue.main.async {
					self.live = response
				}
			default: ()
			}
		}
	}
	
	private func signout () {
		authorize.store(nil)
		presentation.wrappedValue.dismiss()
	}
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}
