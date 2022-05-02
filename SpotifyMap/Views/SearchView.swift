import SwiftUI

/**
 This view is shown when a user chooses a song from the search results
 After the user clicks the Confirm button, an API call will be made to add the selected song to the database
 */
struct ConfirmSheetView: View {
    @Environment(\.dismiss) var dismiss
    var id: String
    var songName: String
    var artist: String
    var albumName: String
    var thumbnail: String
    
    init(id: String, songName: String, artist: String, albumName: String, thumbnail: String?) {
        self.id = id
        self.songName = songName
        self.artist = artist
        self.albumName = albumName
        self.thumbnail = thumbnail ?? "unknown"
    }
    
    var body: some View {
        Background {
            VStack(alignment: .center) {
                Image(systemName: "xmark")
                    .padding(.trailing, 15)
                    .padding(.bottom, 50)
                    .font(.system(size: 32))
                    .onTapGesture {
                        dismiss()
                    }
                    .frame(maxWidth: .infinity, alignment: .topTrailing)
                Text("Add to the song list")
                    .font(.system(size: 30))
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 20)
                
                SongCard(songName: songName, artist: artist, albumName: albumName, thumbnail: thumbnail, songId: id)
                    .padding(.bottom, 30)
                Button(action: {
                    // Add the song to the location, then navigate back to SearchView
                    addSongToLocation(locationId: LocationVariables.currentLocationId, spotifySongId: id) {finished in
                        dismiss()
                    }}) {
                        Text("Confirm")
                    }
                    .padding()
                    .padding(.horizontal, 30)
                    .background(Color(hex: 0x1db954))
                    .foregroundColor(Color.black)
                    .clipShape(Capsule())
            }
        }
    }
}

/**
 View for each individual search result
 */
struct SearchCard: View {
    var id: String
    var songName: String
    var artist: String
    var albumName: String
    var thumbnail: String
    var width: CGFloat
    @State private var showingSheet = false
    
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
        .cornerRadius(10)
        .onTapGesture {
            // When the user chooses a song, they will be redirected to the confirmation page
            showingSheet.toggle()
        }
        .sheet(isPresented: $showingSheet) {
            ConfirmSheetView(id: id, songName: songName, artist: artist, albumName: albumName, thumbnail: thumbnail)
        }
    }
}

/**
 In this view, the user can search for songs using voice recognition or the search field
 */
struct SearchView: View {
    @StateObject var speechRecognizer = SpeechRecognizer()
    @State var searchText = ""
    @State var songs: [Song]
    
    var body: some View {
        Background {
            GeometryReader { geometry in
                VStack(alignment: .leading) {
                    HStack {
                        // Search field view.
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .padding(.leading, 12)
                                .font(.system(size: 18))
                            TextField("Search", text: $searchText)
                                .font(.system(size: 18))
                                .disableAutocorrection(true)
                                .onChange(of: searchText, perform: {value in
                                    getSearchSongs(search: searchText) {result in
                                        songs = result
                                    }
                                })
                                .onDisappear {
                                    speechRecognizer.stopVoiceRecognition()
                                }
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
                        // Button that toggles voice recognition and assigns the outputText to
                        // the search field. Shows an alert if there are any errors.
                        Button(action: {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.3, blendDuration: 0.3)){
                                speechRecognizer.isRecording.toggle()
                                if speechRecognizer.isRecording {
                                    speechRecognizer.reset()
                                    speechRecognizer.startVoiceRecognition()
                                } else {
                                    speechRecognizer.stopVoiceRecognition()
                                    searchText = speechRecognizer.outputText
                                    print("Speech-to-Text: ", speechRecognizer.outputText)
                                }
                            }
                        })
                        {
                            Image(systemName: "waveform")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundColor(.white)
                                .background(speechRecognizer.isRecording ? Circle().foregroundColor(.red).frame(width: 65, height: 65) : Circle().foregroundColor(Color(hex: 0x461c73)).frame(width: 50, height: 50))
                        }
                        .alert(isPresented: $speechRecognizer.VoiceAlertIsPresented, content: {
                            Alert(title: Text(LocalizedStringKey("Voice Recognition Alert")),
                                  message: Text(LocalizedStringKey("\(speechRecognizer.alertMessage)")),
                                  dismissButton: .default(Text("OK")))
                        })
                        .padding(8)
                    }
                    // If text is inserted to the text field show the results count and render
                    // a SearchCard component for each song that is found.
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

struct SearchView_Preview: PreviewProvider {
    static var previews: some View {
        SearchView(songs: [])
    }
}
