//
//  SearchView.swift
//  SpotifyMap
//
//  Created by iosdev on 22.4.2022.
//

import SwiftUI

struct SearchView: View {
    var body: some View {
        Background{
            Button("Button title") {
                print("Running API search")
                getSearchSongs(search: "Pitbull")
            }
        }.preferredColorScheme(.dark)
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SearchView()
        }
    }
}
