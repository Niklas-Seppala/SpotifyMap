import Foundation

struct SpotifyApi {
    static let AUTHENTICATE = "https://accounts.spotify.com/authorize"
    static let TOKEN_REQUEST = "https://accounts.spotify.com/api/token"
    static let REDIRECT = "http://localhost:8080"
    
    static func USERS_TRACK(songId: String) -> String {
        return "https://api.spotify.com/v1/me/tracks?ids=\(songId)"
    }
    
    static func userTracksContain(songId: String) -> String {
        return "https://api.spotify.com/v1/me/tracks/contains?ids=\(songId)"
    }
    
    static func toggleUserTrack(token: String?, id: String, exists: Bool) async throws -> Void {
        guard let realToken = token else { return }
        guard let url = URL(string: USERS_TRACK(songId: id)) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = !exists ? "PUT" : "DELETE"
        request.setValue("Bearer \(realToken)", forHTTPHeaderField: "Authorization")
        
        let res = try await URLSession.shared.data(for: request)
        if let httpRes = res.1 as? HTTPURLResponse {
            if (httpRes.statusCode != 200) {
                throw SpotifyError.failedToFavourite("Http code: \(httpRes.statusCode)")
            }
        }
    }
    
    static func checkForTrack(token: String?, id: String) async throws -> Bool {
        guard let realToken = token else { return false }
        guard let url = URL(string: userTracksContain(songId: id)) else {
            print("invalid URL")
            return false
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(realToken)", forHTTPHeaderField: "Authorization")
        
        let data = try await URLSession.shared.data(for: request)
        let response = try JSONDecoder().decode([Bool].self, from: data.0)
        if (response.isEmpty) {
            return false
        }
        return response[0]
    }
}
