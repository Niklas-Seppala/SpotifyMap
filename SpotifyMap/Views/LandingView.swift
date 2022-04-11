import SwiftUI

struct LandingView: View {
    var body: some View {
        VStack {
            Text("LOGO")
                .font(.system(size: 60))
            
            Spacer()
            
            ShadowRect(height: 260) {
                Text("Connect your")
                    .font(.system(size: 30))
                
                Image("SpotifyLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 70)
            }
            
            Spacer()
            Spacer()
            
            ShadowRect(height: 250) {
            
            Text("Continue as a guest")
                .font(.title)
            Text("with limited features")
                .font(.title2)
            
            Image(systemName: "person")
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
            }
            Spacer()
        }
        .tint(.green)
    }
}

struct LandingView_Previews: PreviewProvider {
    static var previews: some View {
        LandingView()
    }
}
