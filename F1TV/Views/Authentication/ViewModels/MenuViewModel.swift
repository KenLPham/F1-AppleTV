//
//  ContentViewModel.swift
//  F1TV
//
//  Created by Kenneth Pham on 6/12/21.
//  Copyright © 2021 Phez Technologies. All rights reserved.
//

import SwiftUI
import Combine
import os.log

class ContentViewModel: ObservableObject {
    @Environment(\.apiClient) var apiClient
    
    @Published var live: LiveResponse?
    
    var cancellables = [AnyCancellable]()
    
    func load () {
        apiClient.getVideoContainers().sink {
            switch $0 {
            case .failure(let error):
                Logger.apiClient.error("\(String(describing: error))")
            default: ()
            }
        } receiveValue: { _ in
        }.store(in: &cancellables)
    }
}
