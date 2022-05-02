import SwiftUI
import WebKit

struct SpotifyAuthView: UIViewRepresentable {
    // TODO: Move to environment object pattern.
    @ObservedObject var authManager: AuthManager
    
    func makeCoordinator() -> SpotifyAuthView.Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> WKWebView  {
        let view = WKWebView()
        view.navigationDelegate = context.coordinator
        view.load(URLRequest(url: authManager.signInURL!))
        return view
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {}
    
    class Coordinator: NSObject, WKNavigationDelegate {
        let parent: SpotifyAuthView
        
        init(_ parent: SpotifyAuthView) {
            self.parent = parent
        }
        
        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            guard let url = webView.url else { return }
            
            let components = URLComponents(string: url.absoluteString)
            guard let code = components?.queryItems?.first(where: {$0.name == "code"})?.value else {
                return
            }
            
            // No need to display redirect site, we just want the URL querystring.
            webView.isHidden = true
            
            parent.authManager.getTokenWithCode(code: code)
        }
    }
}

struct SpotifyAuthView_Previews: PreviewProvider {
    static var previews: some View {
        Background {
            SpotifyAuthView(authManager: AuthManager())
        }
    }
}
