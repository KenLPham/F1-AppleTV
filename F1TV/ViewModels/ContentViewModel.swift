//
//  ContentViewModel.swift
//  F1TV
//
//  Created by Kenneth Pham on 6/13/21.
//  Copyright © 2021 Phez Technologies. All rights reserved.
//

import SwiftUI
import Combine
import os.log

class ContentViewModel: MenuViewModel, PageViewModel {
    @Environment(\.apiClient) var apiClient
    
    @Published var menuContainers: [MenuContainer]?
    @Published var pageContainers: [PageContainer]?
    
    private var cancellables = [AnyCancellable]()
    
    func load () {
        // load menu
        apiClient.getMenu().handleErrors(handleErrors).map(\.resultObj.containers).receive(on: DispatchQueue.main).sink {
            self.menuContainers = $0
        }.store(in: &cancellables)
        
        // load home as default page
        self.loadHome()
    }
    
    func loadPage (_ container: MenuContainer) {
        guard let path = container.actions.first?.uri else {
            return Logger.client.critical("Menu \(container.id) doesn't have any actions")
        }
        apiClient.getPage(atPath: path).handleErrors(handleErrors).map(\.resultObj.containers).receive(on: DispatchQueue.main).sink {
            self.pageContainers = $0
        }.store(in: &cancellables)
    }
    
    private func loadHome () {
        apiClient.getPage(forId: 395).handleErrors(handleErrors).map(\.resultObj.containers).receive(on: DispatchQueue.main).sink {
            self.pageContainers = $0
        }.store(in: &cancellables)
    }
}
