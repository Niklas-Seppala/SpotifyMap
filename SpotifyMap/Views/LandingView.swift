import SwiftUI

struct LandingView: View {
    @State var displayWeb = false
    
    var body: some View {
        VStack {
            Spacer()
            Image("AppLogo")
                .resizable()
                .scaledToFit()
                .frame(width: 250, height: 50)
                .padding(.bottom, 30)
            Spacer()
            SpotifyAuthButton()
            Spacer()
            Spacer()
            VisitorAuthButton()
            Spacer()
        }
    }
}
