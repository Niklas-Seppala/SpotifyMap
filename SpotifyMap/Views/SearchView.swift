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
            VStack(alignment: .leading){
                HStack{
                    Image(systemName: "magnifyingglass")
                    TextField("Search",text: $searchText)
                        .onSubmit {
                            print("Running API search")
                            getSearchSongs(search: searchText)
                        }.submitLabel(.search)
                }
                .padding(.leading, 20)
                Spacer()
                Text("test")
                }
        }
        .preferredColorScheme(.dark)
        .navigationTitle("Search")
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SearchView()
        }
    }
}
