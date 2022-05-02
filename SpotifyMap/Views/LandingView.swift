import SwiftUI

struct LandingView: View {
    @State var displayWeb = false
    
    var body: some View {
        VStack {
            Spacer()
            Text("LOGO")
                .font(.system(size: 60))
            Spacer()
            SpotifyAuthButton()
            Spacer()
            Spacer()
            VisitorAuthButton()
            Spacer()
        }
    }
}
