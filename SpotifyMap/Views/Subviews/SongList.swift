import SwiftUI

struct SongCard: View {
    let songName = "Hotel Room Service"
    let musician = "Pitbull"
    let albumName = "Rebelution"
    
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
    var body: some View {
        ScrollView (.horizontal) {
            HStack {
                ForEach(0...4, id: \.self) {index in
                    Spacer()
                    SongCard()
                    Spacer()
                }
            }
        }
        .padding(.top, 12)
    }
}

struct SongList_Previews: PreviewProvider {
    static var previews: some View {
        SongList()
    }
}
