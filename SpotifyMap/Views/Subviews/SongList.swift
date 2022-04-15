import SwiftUI

struct SongCard: View {
    var body: some View {
        VStack(alignment: .leading) {
            Image("AlbumCoverPlaceholder")
                .resizable()
                .scaledToFit()
                .frame(width: 220, height: 220)
            Text("Hotel Room Service")
                .fontWeight(.bold)
            Text("Pitbull")
                .font(.callout)
            Text("Rebelution")
                .font(.callout)
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
