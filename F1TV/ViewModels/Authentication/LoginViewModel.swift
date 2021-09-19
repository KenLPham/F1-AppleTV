//
//  LoginViewModel.swift
//  F1TV
//
//  Created by Kenneth Pham on 6/12/21.
//  Copyright © 2021 Phez Technologies. All rights reserved.
//

import SwiftUI
import Combine
import os.log

class LoginViewModel: ObservableObject {
    @Environment(\.authorized) var authorize
    
    @Published var credentials = Credentials()
    @Published var alertItem: LoginAlerts?

    public func login () {
        guard credentials.isComplete else {
            Logger.client.info("Tried to login with no credentials filled out")
            self.alertItem = .empty
            return
        }
        
        authorize.tryCredentials(credentials) { error in
            DispatchQueue.main.async {
                switch error {
                case .unauthorized:
                    Logger.apiClient.error("Access denied: \(String(describing: error))")
                    self.alertItem = .denied
                default:
                    Logger.apiClient.error("Unknown Login Error: \(String(describing: error))")
                    self.alertItem = .failed
                }
            }
        }
    }
}


enum LoginAlerts: String {
    case denied = "Incorrect Username or Password", empty = "No credentials provided", failed = "Unexpected error occurred. Please try again."
}

extension LoginAlerts: Identifiable {
    var id: String {
        self.rawValue
    }
}
