import SwiftUI

// Button that toggles target track in AUTHORIZED users
// Spotify library favourites. Button icon works the same way
// button in spotify app (style state).
struct SpotifyFavButton: View {
    @EnvironmentObject var authManager: AuthManager
    @State var iconName: String = HeartIcon.Inactive.rawValue
    let songId: String
    
    var body: some View {
        Button {
            Task {
                let token = await authManager.accessTokenAsync()
                do {
                    // Check if track is already in favourites.
                    let exists = iconName == HeartIcon.Active.rawValue
                    
                    try await SpotifyApi.toggleUserTrack(token: token, id: songId, exists: exists)
                    DispatchQueue.main.async {
                        iconName = !exists ? HeartIcon.Active.rawValue : HeartIcon.Inactive.rawValue
                    }
                } catch {
                    print("Spotify favourite call failed.")
                }
            }
        } label: {
            Image(systemName: iconName)
                .font(.system(size: 30))
                .foregroundColor(iconName == HeartIcon.Active.rawValue ? Color(hex: 0x1ED760) : Color(.gray))
        }.onAppear {
            Task {
                // Check if track is already in favourites.
                let token = await authManager.accessTokenAsync()
                let exists = try await SpotifyApi.checkForTrack(token: token, id: songId)
                DispatchQueue.main.async {
                    iconName = exists ? HeartIcon.Active.rawValue : HeartIcon.Inactive.rawValue
                }
            }
        }
    }
    
    enum HeartIcon: String {
        case Active = "heart.fill"
        case Inactive = "heart"
    }
}
