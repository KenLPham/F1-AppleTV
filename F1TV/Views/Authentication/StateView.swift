//
//  StateView.swift
//  F1TV
//
//  Created by Kenneth Pham on 10/3/20.
//  Copyright © 2020 Phez Technologies. All rights reserved.
//

import SwiftUI

struct LoadView: View {
    @Environment(\.appState) var appState
    @Environment(\.authorized) var authorize
    
    var body: some View {
        Text("F1TV").onAppear(perform: validate)
    }
    
    private func validate () {
        appState.option = authorize.credentials == nil ? .notAuthorized : .authorized
    }
}

struct StateView: View {
    @Environment(\.appState) var appState
    @State var navigator: AppState.Option?
    
    var body: some View {
        Group {
            if let nav = self.navigator {
                switch nav {
                case .authorized:
                    NavigationView {
                        MenuView()
                    }
                case .notAuthorized:
                    NavigationView {
                        LoginView()
                    }
                }
            } else {
                LoadView()
            }
        }.onReceive(appState.$option) {
            self.navigator = $0
        }
    }
}

// MARK: - Environment Extension
class AppState: ObservableObject {
    @Published var option: Option?
}

extension AppState {
    enum Option: Int {
        case authorized, notAuthorized
    }
}

extension AppState {
    struct Key: EnvironmentKey {
        static var defaultValue = AppState()
    }
}

extension EnvironmentValues {
    var appState: AppState {
        get {
            self[AppState.Key.self]
        }
        set {
            self[AppState.Key.self] = newValue
        }
    }
}
