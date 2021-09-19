//
//  AuthorizedKey.swift
//  F1TV
//
//  Created by Ken Pham on 7/2/20.
//  Copyright © 2020 Phez Technologies. All rights reserved.
//

import SwiftUI
import KeychainAccess
import Combine
import os

extension Data {
	func decode<T: Decodable> (to type: T.Type) -> T? {
		try? JSONDecoder().decode(type, from: self)
	}
}

class AuthorizedObject: ObservableObject {
    @Environment(\.apiClient) var apiClient
    @Environment(\.appState) var appState
    
	private var keychain = Keychain(service: "com.kpham.auth")
    private static let credentialsKey = "credentials"
	
	@Published var session: AuthenticationResponse?
	
    private var cancellables = [AnyCancellable]()
    
    func authenticate () {
        if let credentials = try? keychain.getData(AuthorizedObject.credentialsKey)?.decode(to: Credentials.self) {
            self.tryCredentials(credentials, errorHandler: errorHandler)
        } else {
            DispatchQueue.main.async {
                self.appState.option = .notAuthorized
            }
        }
    }
    
    func tryCredentials (_ credentials: Credentials, errorHandler: @escaping (Lite.Errors) -> ()) {
        apiClient.authenticate(with: credentials).handleErrors(errorHandler).receive(on: DispatchQueue.main).sink { response in
            self.store(credentials)
            self.session = response
            self.appState.option = .authorized
        }.store(in: &cancellables)
    }
    
    func errorHandler (_ error: Lite.Errors) {
        self.handleErrors(error)
        self.signOut()
    }
    
    func signOut () {
        self.store(nil)
        appState.option = .notAuthorized
    }
    
    func store (_ credentials: Credentials?) {
        do {
            if let data = credentials?.encode() {
                Logger.auth.info("[\(self.className)] Stored credentials")
                try keychain.set(data, key: AuthorizedObject.credentialsKey)
            } else {
                Logger.auth.info("[\(self.className)] Removing stored credentials")
                try keychain.remove("credentials")
            }
        } catch {
            Logger.auth.error("[\(self.className)] Failed to update credentials \(credentials?.email ?? "", privacy: .private) with error: \(String(describing: error))")
        }
    }
}

struct AuthorizedKey: EnvironmentKey {
	static let defaultValue = AuthorizedObject()
}

extension EnvironmentValues {
	var authorized: AuthorizedObject {
		get {
			self[AuthorizedKey.self]
		}
		set {
			self[AuthorizedKey.self] = newValue
		}
	}
}
