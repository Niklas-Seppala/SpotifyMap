import SwiftUI

struct LandingView: View {
    @State var displayWeb = false
    
    var body: some View {
        VStack {
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

struct LandingView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            LandingView()
        }
    }
}
