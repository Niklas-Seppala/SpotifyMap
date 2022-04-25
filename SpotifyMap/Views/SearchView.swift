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
                        .onSubmit {
                            print("Running API search")
                            getSearchSongs(search: searchText)
                        }.submitLabel(.search)
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
