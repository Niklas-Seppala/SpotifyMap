import SwiftUI
import MapKit
import CoreLocationUI
import PopupView
import WebKit
/*
Button("Add song") {
    Task {
        guard authManager.isSignedIn else { return }
        guard let token = await authManager.accessTokenAsync() else { return }
        
        print(token)
        
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "ids", value: "11dFghVXANMlKmJXsNCbNl"),
        ]
        
        var request = URLRequest(url: URL(string: "https://api.spotify.com/v1/me/tracks")!)
        request.httpMethod = "PUT"
        request.httpBody = components.query?.data(using: .utf8)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token.data(using: .utf8)?.base64EncodedString())", forHTTPHeaderField: "Authorization")
        
        do {
            let res = try await URLSession.shared.data(for: request)
            print(res);
            showToastMessage(toastText: "Added song to your library.")
            
        } catch {
            throw AuthError.network("Fetching failed")
        }
    }
}
*/
struct SpotifyWebView: UIViewRepresentable {
    var trackURL: URL
    
    init(track: String) {
        self.trackURL = URL(string: "https://open.spotify.com/track/\(track)")!
    }
    
    func makeUIView(context: Context) -> WKWebView  {
        let view = WKWebView()
        view.load(URLRequest(url: self.trackURL))
        return view
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {}
}

struct HomeView: View {
    @StateObject var viewModel = MapViewModel()
    @EnvironmentObject var authManager: AuthManager
    @State var showingToast = false
    @State var toastMessage = ""
    @State var showBrowser = false
    
    func showToastMessage(toastText: String) {
        toastMessage = toastText
        showingToast = true
    }
    
    var body: some View {
        NavigationView {
            Background {
                GeometryReader { geometry in
                    VStack(spacing: 0){
                        ZStack(alignment: .top) {
                            Map(coordinateRegion: $viewModel.region, showsUserLocation: true)
                                .frame(height: geometry.size.height - 390)
                                .popup(isPresented:$showingToast, type:.toast, position: .top, autohideIn: 10.0) {
                                    createTopToast(toastText: toastMessage)
                                }
                                .onAppear {
                                    viewModel.requestLocation()
                                }
                        }
                        .frame(height: geometry.size.height - 390)
                        CircleButton(xOffset: geometry.size.width - 38, yOffset: -104, action: {
                            viewModel.checkLocationAuthorization()
                        }) {
                            Image(systemName: "location.fill")
                                .font(.system(size: 22))
                        }
                        .alert(isPresented: $viewModel.alertIsPresented, content: {
                            Alert(title: Text("Location Alert"),
                                  message: Text("Please give location permissions to this app in order to locate you."),
                                  dismissButton: .default(Text("Cancel")))
                        })
                        CircleButton(xOffset: geometry.size.width - 38, yOffset: -43, action: {}) {
                            NavigationLink(destination: SearchView( songs: [])){
                                Image(systemName: "plus")
                                    .font(.system(size: 28))
                            }
                        }
                        Text(LocalizedStringKey(viewModel.regionName.isEmpty ? " " : "The Sound of \(viewModel.regionName)"))
                            .frame(width: geometry.size.width, alignment: .center)
                            .font(.title2)
                            .padding(.vertical, 12)
                            .background(Color.black.opacity(0.3))
                        SongList(requestManager: viewModel.requestManager)
                    }
                }
                .edgesIgnoringSafeArea(.top)
                .navigationBarBackButtonHidden(true)
            }
        }
        .task {
            if authManager.isSignedIn {
                showToastMessage(toastText: "Connected with Spotify")
            }
        }
    }
}
