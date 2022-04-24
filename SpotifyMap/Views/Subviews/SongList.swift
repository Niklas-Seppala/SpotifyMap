import SwiftUI

struct SongCard: View {
    var songName = ""
    let musician = "Musician"
    let albumName = "Album"
    
    init(songName: String) {
        self.songName = songName
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Image("AlbumCoverPlaceholder")
                .resizable()
                .scaledToFit()
                .frame(width: 220, height: 220)
            Text(songName)
                .fontWeight(.bold)
                .padding(.horizontal, 5)
            HStack() {
                VStack(alignment: .leading) {
                    Text(musician)
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
        if (requestManager.songs.count > 0) {
            ScrollView (.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(requestManager.songs, id: \.self) {song in
                        Spacer()
                        SongCard(songName: song.name)
                        Spacer()
                    }
                }
            }
            .padding(.top, 12)
        } else {
            Text("No songs found in this area")
                .frame(height: 330)
        }
    }
}
