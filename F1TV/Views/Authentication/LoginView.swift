//
//  LoginView.swift
//  F1TV
//
//  Created by Ken Pham on 7/2/20.
//  Copyright © 2020 Phez Technologies. All rights reserved.
//

import SwiftUI

struct Lazy<Content: View>: View {
	var content: () -> Content
	
	init (_ content: @autoclosure @escaping () -> Content) {
		self.content = content
	}
	
	var body: Content {
		content()
	}
}

struct LoginView: View {
	@Environment(\.authorized) var authorize
    @Environment(\.appState) var appState
	
	@State var credentials = Credentials()
	@State var failed = false
	
	var body: some View {
		ZStack {
			// MARK: Main View
			HStack {
				Spacer()
				VStack {
					TextField("Email", text: $credentials.email).textContentType(.emailAddress)
					SecureField("Password", text: $credentials.password).textContentType(.password)
					Button("Login") {
						Skylark.shared.authenticate(with: self.credentials) { result in
							switch result {
							case .success(let response):
								DispatchQueue.main.async {
									self.failed = false
									self.authorize.store(response)
                                    appState.option = .authorized
								}
							case .failure(let response):
								switch response {
								case .unauthorized:
									DispatchQueue.main.async {
										self.failed = true
									}
								default: ()
								}
							}
						}
					}
				}
				Spacer()
			}
			// MARK: Toast
			if failed {
				VStack {
					Text("Incorrect Username or Password").foregroundColor(.white).padding().background(Color.red).mask(RoundedRectangle(cornerRadius: 8, style: .continuous))
					Spacer()
				}
			}
		}.navigationBarTitle("F1TV")
    }
}

#if DEBUG
struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
#endif
