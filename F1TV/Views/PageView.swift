//
//  PageView.swift
//  F1TV
//
//  Created by Kenneth Pham on 6/13/21.
//  Copyright © 2021 Phez Technologies. All rights reserved.
//

import SwiftUI

struct PageView<ViewModel: PageViewModel>: View {
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                if let containers = viewModel.pageContainers {
                    ForEach(containers) { container in
                        switch container.layout {
                        case .gpBanner:
                            BannerView(item: container)
                        case .hero:
                            VideoContainerView<HeroItemView>(item: container)
                        case .horizontal:
                            VideoContainerView<HorizontalItemView>(item: container)
                        case .vertical:
                            VideoContainerView<VerticalItemView>(item: container)
                        case .title:
                            // - TODO: make titles clickable if they have an action
                            if let title = container.metadata.label {
                                Text(title).font(.title2)
                            }
                        case .subtitle:
                            if let subtitle = container.metadata.label {
                                Text(subtitle).font(.footnote)
                            }
                        case .schedule:
                            ScheduleView(container: container)
                        }
                    }
                }
            }
        }
    }
}
