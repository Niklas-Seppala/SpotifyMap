import SwiftUI

struct SpotifyAuthButton: View {
    @EnvironmentObject var authManager: AuthManager
    @State var displayWeb = false
    
    private func delayRedirect() async {
        try? await Task.sleep(nanoseconds: 130000000)
    }
    
    var body: some View {
        Button("") {
            Task {
                await delayRedirect()
                displayWeb = true
            }
        }
        .buttonStyle(SpotifyButtonStyle())
        .sheet(isPresented: $displayWeb) {
            Button("Cancel") { displayWeb = false }.padding(.top)
            SpotifyAuthView(authManager: authManager)
        }
    }
    
    private struct SpotifyButtonStyle: ButtonStyle {
        func makeBody(configuration: Self.Configuration) -> some View {
            ShadowRect(height: 250) {
                Text(LocalizedStringKey("Connect your"))
                    .font(.system(size: 30))
                    
                Image("SpotifyLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 70)
            }
            .scaleEffect(configuration.isPressed ? 0.8 : 1.0)
        }
    }
}
