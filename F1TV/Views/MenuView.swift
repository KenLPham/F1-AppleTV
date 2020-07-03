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
    var body: some View {
		VStack {
			NavigationLink(destination: Lazy(SeasonsView())) {
				Text("Archive")
			}
		}.navigationBarTitle("F1TV").navigationBarItems(trailing: SignoutButton())
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}
