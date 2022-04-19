import SwiftUI

struct ContentView: View {
    @StateObject var authManager = AuthManager()
    
    var body: some View {
        if authManager.isLoading {
            // Show loading spinner while cached accesss token is being fetched.
            LoadingView(title: "")
        } else {
            Background {
                if authManager.isSignedIn || authManager.isAnonymous {
                    // Cached access token found, or user selected guest visit.
                    HomeView(authManager: authManager)
                } else {
                    // Login options: Spotify or guest.
                    LandingView(authManager: authManager)
                }
            }
            .foregroundColor(.white)
            .transition(.opacity)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
