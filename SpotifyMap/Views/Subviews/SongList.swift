import SwiftUI

struct SongLoading: View {
    
    var body: some View {
        LoadingView(title: "")
    }
}

struct SongCard: View {
    var songName: String
    var artist: String
    var albumName: String
    var thumbnail: String
    
    init(songName: String, artist: String?, albumName: String?, thumbnail: String?) {
        self.songName = songName
        self.artist = artist ?? ""
        self.albumName = albumName ?? ""
        self.thumbnail = thumbnail ?? "unknown"
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            if (thumbnail == "unknown") {
                Image("AlbumCoverPlaceholder")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 220, height: 220)
            } else {
                AsyncImage(url: URL(string: thumbnail)) {image in
                    image.resizable()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 220, height: 220)
            }
            Text(songName)
                .fontWeight(.bold)
                .padding(.horizontal, 5)
            HStack() {
                VStack(alignment: .leading) {
                    Text(artist)
                        .font(.callout)
                    Text(albumName)
                        .font(.callout)
                }
                .frame(width: 160, alignment: .leading)
                Image("SpotifyLogoNoText")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
            }
            .padding(.horizontal, 5)
        }
        .frame(width: 220, height: 320, alignment: .topLeading)
        .background(Color.black.opacity(0.3))
    }
}

struct SongList: View {
    @ObservedObject var requestManager: RequestManager
    
    var body: some View {
        if (!requestManager.isLoading) {
            if(requestManager.songs.count > 0) {
                ScrollView (.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(requestManager.songs, id: \.self) {song in
                            Spacer()
                            SongCard(songName: song.name, artist: song.artist, albumName: song.albumName, thumbnail: song.albumThumb)
                            Spacer()
                        }
                    }
                }.padding(.top, 12)
            } else {
                Text("No songs found in this area")
                    .frame(height: 330)
            }
        } else {
            SongLoading()
        }
    }
}
