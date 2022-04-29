import SwiftUI

struct ContentView: View {
    @StateObject var authManager = AuthManager()
    
    var body: some View {
        if authManager.isLoading {
            // Show loading spinner while cached accesss token is being fetched.
            LoadingView(title: "")
                .preferredColorScheme(.dark)
        } else {
            Background {
                if authManager.isSignedIn || authManager.isAnonymous {
                    // Cached access token found, or user selected guest visit.
                    HomeView()
                } else {
                    // Login options: Spotify or guest.
                    LandingView()
                }
            }
            .environmentObject(authManager)
            .foregroundColor(.white)
            .transition(.opacity)
            .preferredColorScheme(.dark)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
