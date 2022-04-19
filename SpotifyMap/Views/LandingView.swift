import SwiftUI

struct LandingView: View {
    @ObservedObject var authManager: AuthManager
    @State var displayWeb = false
    
    var body: some View {
        VStack {
            Text("LOGO")
                .font(.system(size: 60))
            Spacer()
            
            // Spotify login.
            ShadowRect(height: 250) {
                Text("Connect your")
                    .font(.system(size: 30))
                    
                Image("SpotifyLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 70)
            }.onTapGesture { displayWeb = true }
            .sheet(isPresented: $displayWeb) {
                SpotifyAuthView(authManager: authManager)
            }
            
            Spacer()
            Spacer()
            
            // Guest login.
            ShadowRect(height: 250) {
                Text("Continue as a guest")
                    .font(.title)
                Text("with limited features")
                    .font(.title2)
                
                Image(systemName: "person")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
            }.onTapGesture {
                withAnimation {
                    authManager.isAnonymous = true
                }
            }
            Spacer()
        }
        .tint(.green)
        .preferredColorScheme(.dark)
    }
}

struct LandingView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            LandingView(authManager: AuthManager())
        }
    }
}
