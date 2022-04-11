import SwiftUI
import WebKit

let SPOTIFY_AUTH_URL = "https://accounts.spotify.com/authorize"

struct SpotifyAuthView: UIViewRepresentable {
    let request = URLRequest(url: URL(string: SPOTIFY_AUTH_URL)!)
    
    func makeUIView(context: Context) -> WKWebView  {
        return WKWebView()
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.load(request)
    }
}

struct SpotifyAuthView_Previews: PreviewProvider {
    static var previews: some View {
        Background {
            SpotifyAuthView()
        }
    }
}
