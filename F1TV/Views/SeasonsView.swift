//
//  SeasonsView.swift
//  F1TV
//
//  Created by Ken Pham on 7/2/20.
//  Copyright © 2020 Phez Technologies. All rights reserved.
//

import SwiftUI

struct SeasonsView: View {
	@State var seasons = [RaceSeason]()
	
    var body: some View {
		List {
			ForEach(seasons.filter({ $0.hasContent })) { season in
				NavigationLink(destination: SeasonView(season: season)) {
					Text(season.name)
				}
			}
		}.navigationBarTitle("Seasons").onAppear(perform: load)
    }
	
	private func load () {
		guard seasons.isEmpty else { return }
		Skylark.shared.getSeasons { result in
			switch result {
			case .success(let response):
				DispatchQueue.main.async {
					self.seasons = response.objects
				}
			default: ()
			}
		}
	}
}

struct SeasonsView_Previews: PreviewProvider {
    static var previews: some View {
        SeasonsView()
    }
}
