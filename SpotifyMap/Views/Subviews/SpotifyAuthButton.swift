import SwiftUI

struct SpotifyAuthButton: View {
    @ObservedObject var authManager: AuthManager
    @State var displayWeb = false
    
    private func delayRedirect() async {
        try? await Task.sleep(nanoseconds: 130000000)
    }
    
    var body: some View {
        Button("Connect your") {
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
                configuration.label
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