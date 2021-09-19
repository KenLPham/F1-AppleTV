//
//  LoginView.swift
//  F1TV
//
//  Created by Ken Pham on 7/2/20.
//  Copyright © 2020 Phez Technologies. All rights reserved.
//

import SwiftUI
import Combine

struct LoginView: View {
    @Environment(\.appState) var appState
    @StateObject var viewModel = LoginViewModel()
    
	var body: some View {
        VStack {
            Image("Logo")
            Spacer()
            TextField("Email", text: $viewModel.credentials.email).textContentType(.emailAddress)
            SecureField("Password", text: $viewModel.credentials.password).textContentType(.password)
            Button("Login", action: viewModel.login)
            Spacer()
        }.alert(item: $viewModel.alertItem) {
            Alert(title: Text("Sign In Failed"), message: Text($0.rawValue), dismissButton: nil)
        }
    }
}
