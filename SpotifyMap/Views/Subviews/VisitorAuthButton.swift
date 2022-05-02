import SwiftUI

struct VisitorAuthButton: View {
    @EnvironmentObject var authManager: AuthManager
    
    private func delayRedirect() async {
        try? await Task.sleep(nanoseconds: 150000000)
    }
    
    var body: some View {
        Button("") {
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
                Text(LocalizedStringKey("Continue as a guest"))
                    .font(.title)
                Text(LocalizedStringKey("with limited features"))
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
