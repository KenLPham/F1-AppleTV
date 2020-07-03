//
//  MenuView.swift
//  F1TV
//
//  Created by Ken Pham on 7/2/20.
//  Copyright © 2020 Phez Technologies. All rights reserved.
//

import SwiftUI

struct SignoutButton: View {
	var body: some View {
		Button("Signout") {
			print("todo")
		}
	}
}

struct MenuView: View {
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
		}.navigationBarTitle("F1TV").navigationBarItems(trailing: SignoutButton()).onAppear(perform: load)
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
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}
