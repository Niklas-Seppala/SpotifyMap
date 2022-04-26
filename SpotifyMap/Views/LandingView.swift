import SwiftUI

struct LandingView: View {
    @ObservedObject var authManager: AuthManager
    @State var displayWeb = false
    
    var body: some View {
        VStack {
            Text("LOGO")
                .font(.system(size: 60))
            Spacer()
            SpotifyAuthButton(authManager: authManager)
            Spacer()
            Spacer()
            VisitorAuthButton(authManager: authManager)
            Spacer()
        }
        //.preferredColorScheme(.dark)
    }
}

struct LandingView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            LandingView(authManager: AuthManager())
        }
    }
}
