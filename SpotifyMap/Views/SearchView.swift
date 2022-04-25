//
//  SearchView.swift
//  SpotifyMap
//
//  Created by iosdev on 22.4.2022.
//

import SwiftUI
struct SearchView: View {
@State var searchText = ""
    var body: some View {
        Background{
            VStack{
                HStack{
                    Image(systemName: "magnifyingglass")
                    TextField("Search",text: $searchText)
                    Button("Search") {
                        print("Running API search")
                        getSearchSongs(search: searchText)
                    }
                    .padding(.trailing, 10)
                }
                .padding(.leading, 10)
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
