import SwiftUI

struct VisitorAuthButton: View {
    @ObservedObject var authManager: AuthManager

    private func delayRedirect() async {
        try? await Task.sleep(nanoseconds: 150000000)
    }
    
    var body: some View {
        Button("Continue as a guest") {
            Task {
                await delayRedirect()
                withAnimation {
                    authManager.isAnonymous = true
                }
                
            }
        }
        .buttonStyle(GuestButtonStyle())
    }
    
    private struct GuestButtonStyle: ButtonStyle {
        func makeBody(configuration: Self.Configuration) -> some View {
            ShadowRect(height: 250) {
                configuration.label
                    .font(.title)
                Text("with limited features")
                    .font(.title2)
                
                Image(systemName: "person")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
            }
            .scaleEffect(configuration.isPressed ? 0.8 : 1.0)
        }
    }
}
