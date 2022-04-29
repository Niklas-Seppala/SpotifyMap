import SwiftUI

struct SearchCard: View {
    var id: String
    var songName: String
    var artist: String
    var albumName: String
    var thumbnail: String
    var width: CGFloat
    
    init(id: String, songName: String, artist: [Artist], albumName: String?, thumbnail: String?, width: CGFloat) {
        self.id = id
        self.songName = songName
        self.artist = String(String(artist.map { (artist) -> String in return artist.name }.reduce("") {$0 + ", " + $1}.dropFirst()).dropFirst())
        self.albumName = albumName ?? ""
        self.thumbnail = thumbnail ?? "unknown"
        self.width = width
    }
    
    var body: some View {
        HStack(alignment: .center) {
            if (thumbnail == "unknown") {
                Image("AlbumCoverPlaceholder")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
            } else {
                AsyncImage(url: URL(string: thumbnail)) {image in
                    image.resizable()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 100, height: 100)
            }
            VStack(alignment: .leading) {
                Text(songName)
                    .font(.callout)
                    .fontWeight(.bold)
                    .lineLimit(2)
                Text(artist)
                    .font(.system(size: 14))
                    .lineLimit(1)
                Text(albumName)
                    .font(.system(size: 14))
                    .lineLimit(1)
            }
            .padding(.trailing, 5)
            .frame(width: width - 130, alignment: .leading)
        }
        .frame(width: width - 30, height: 100, alignment: .topLeading)
        .background(Color.black.opacity(0.3))
        .onTapGesture {
            print(id)
        }
        .cornerRadius(5)
    }
}


struct SearchView: View {
    @State var searchText = ""
    @State var songs: [Song]
    
    var body: some View {
        Background {
            GeometryReader { geometry in
                VStack(alignment: .leading) {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .padding(.leading, 12)
                            .font(.system(size: 18))
                        TextField("Search", text: $searchText)
                            .font(.system(size: 18))
                            .onChange(of: searchText, perform: {value in
                                getSearchSongs(search: searchText) {result in
                                    songs = result
                                }
                            })
                        if (!searchText.isEmpty) {
                            Image(systemName: "xmark")
                                .font(.system(size: 18))
                                .padding(.horizontal, 14)
                                .frame(alignment: .trailing)
                                .onTapGesture {
                                    searchText = ""
                                }
                        }
                    }
                    .padding(.vertical, 14)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.white, lineWidth: 1))
                    
                    if(!searchText.isEmpty) {
                        Text(LocalizedStringKey("Showing \(songs.count) results"))
                            .padding(.vertical, 6)
                        ScrollView {
                            ForEach(songs) {song in
                                SearchCard(id: song.id, songName: song.name, artist: song.artists, albumName: song.album.name, thumbnail: song.album.images[0].url, width: geometry.size.width)
                                Spacer()
                            }
                        }
                    } else {
                        VStack {
                            Image("SearchPlaceholder")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 150, height: 150)
                                .padding(.bottom, 50)
                        }
                        .frame(width: geometry.size.width - 30, height: geometry.size.height)
                    }
                    
                }.padding(.horizontal, 15)
            }
        }
        .preferredColorScheme(.dark)
        .navigationTitle("Search")
    }
}
