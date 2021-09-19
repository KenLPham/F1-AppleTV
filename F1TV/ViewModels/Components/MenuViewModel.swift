//
//  MenuViewModel.swift
//  F1TV
//
//  Created by Kenneth Pham on 6/13/21.
//  Copyright © 2021 Phez Technologies. All rights reserved.
//

import SwiftUI

protocol MenuViewModel: ObservableObject {
    func loadPage (_ container: MenuContainer)
}
