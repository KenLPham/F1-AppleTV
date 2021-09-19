//
//  DetailPageViewModel.swift
//  F1TV
//
//  Created by Ken Pham on 8/26/21.
//  Copyright © 2021 Phez Technologies. All rights reserved.
//

import SwiftUI
import Combine

class DetailPageViewModel: PageViewModel {
    @Environment(\.apiClient) var apiClient
    
    @Published var pageContainers: [PageContainer]?
    
    private var cancellables = [AnyCancellable]()
    
    init (_ uri: String) {
        apiClient.getPage(atPath: uri).handleErrors(handleErrors).map(\.resultObj.containers).receive(on: DispatchQueue.main).sink {
            self.pageContainers = $0
        }.store(in: &cancellables)
    }
}
