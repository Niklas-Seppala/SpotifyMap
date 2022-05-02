import SwiftUI
import WebKit

/**
 View component that opens a web view for specified
 Spotify track. Does not need Spotify OAuth token.
*/
struct SpotifyTrackWebView: UIViewRepresentable {
    let track: String
    var trackURL: URL? {
        return  URL(string: "https://open.spotify.com/track/\(track)")
    }
    
    func makeUIView(context: Context) -> WKWebView  {
        let view = WKWebView()
        guard let url = self.trackURL else {
            print("Opening spotify track web view failed. Bad URL.")
            return view
        }
        view.load(URLRequest(url: url))
        return view
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {}
}
