//
//  LoginView.swift
//  F1TV
//
//  Created by Ken Pham on 7/2/20.
//  Copyright © 2020 Phez Technologies. All rights reserved.
//

import SwiftUI
import Combine

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
    @Environment(\.appState) var appState
	@StateObject var state = ViewState()
    
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
                        state.login(credentials)
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

extension LoginView {
    class ViewState: ObservableObject {
        @Environment(\.authorized) var authorize
        @Environment(\.apiClient) var skylark
        @Environment(\.appState) var appState
        
        var cancellables = [AnyCancellable]()
        
        public func login (_ credentials: Credentials) {
            skylark.authenticate(with: credentials).receive(on: DispatchQueue.main).sink {
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
                self.authorize.store($0)
                self.appState.option = .authorized
            }.store(in: &cancellables)
        }
    }
}
