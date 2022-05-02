import Foundation
import SwiftUI

class AuthManager: ObservableObject {
    @Published var isSignedIn = false
    @Published var isAnonymous = false
    @Published var isLoading = true
    
    var spotifySecret: String
    var spotifyId: String
    
    struct Keys {
        // For storage.
        static let EXPIRATION = "EXPIRATION_DATE"
        static let ACCESS_TOKEN = "ACCESS_TOKEN"
        static let REFRESH_TOKEN = "REFRESH_TOKEN"
    }
    
    init() {
        guard let id = Bundle.main.infoDictionary?["APP_ID"] as? String else {
            fatalError("SPOTIFY APP ID IS MISSING")
        }
        guard let secret = Bundle.main.infoDictionary?["APP_SECRET"] as? String else {
            fatalError("SPOTIFY APP SECRET IS MISSING")
        }
        
        spotifyId = id
        spotifySecret = secret
        
        signIn()
        //signOut() // Uncomment this to clear cache at the startup.
    }
    
    public var signInURL: URL? {
        let scope = "user-library-modify%20user-library-read"
        let str = "\(SpotifyApi.AUTHENTICATE)?response_type=code&client_id=\(spotifyId)&scope=\(scope)&redirect_uri=\(SpotifyApi.REDIRECT)&show_dialog=TRUE"
        return URL(string: str)
    }

    public func getTokenWithCode(code: String) {
        DispatchQueue.main.async {
            self.isLoading = true
        }
        
        guard let url = URL(string: SpotifyApi.TOKEN_REQUEST) else {
            return
        }
        
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "grant_type", value: "authorization_code"),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "redirect_uri", value: SpotifyApi.REDIRECT),
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = components.query?.data(using: .utf8)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        guard let auth = self.basicAuthBase64 else { return }
        request.setValue("Basic \(auth)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    self?.isLoading = false
                }
                return
            }
            // Deserialize response body.
            do {
                let response = try JSONDecoder().decode(AuthResponse.self, from: data)
                self?.cacheToken(response: response)
                self?.signIn()
                DispatchQueue.main.async {
                    self?.isLoading = false
                }
            } catch {
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    self?.isLoading = false
                }
            }
        }
        task.resume()
    }
    
    public func signIn() {
        Task {
            DispatchQueue.main.async {
                self.isLoading = true
            }
            let accessToken = await self.accessTokenAsync()
            DispatchQueue.main.async {
                self.isLoading = false
                self.isSignedIn = accessToken != nil
            }
        }
    }
    
    public func signOut() {
        DispatchQueue.main.async {
            self.isLoading = true
            self.isSignedIn = false
            UserDefaults.standard.removeObject(forKey: Keys.ACCESS_TOKEN)
            UserDefaults.standard.removeObject(forKey: Keys.REFRESH_TOKEN)
            UserDefaults.standard.removeObject(forKey: Keys.EXPIRATION)
            self.isLoading  = false
        }
    }
    
    private var basicAuthBase64: String? {
        let basicToken = spotifyId + ":" + spotifySecret
        let data = basicToken.data(using: .utf8)
        
        guard let base64 = data?.base64EncodedString() else {
            return nil
        }
        return base64
    }
    
    public func refreshIfNeeded() async throws -> Void {
        guard shouldRefresh else {
            return
        }
        guard let refreshToken = self.refreshToken else {
            throw AuthError.missingCache("Failed to refresh")
        }
        guard let url = URL(string: SpotifyApi.TOKEN_REQUEST) else {
            throw AuthError.invalidURL("Failed to refresh")
        }
        
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "grant_type", value: "refresh_token"),
            URLQueryItem(name: "refresh_token", value: refreshToken),
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = components.query?.data(using: .utf8)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        guard let auth = self.basicAuthBase64 else {
            throw AuthError.network("Failed to decode base64")
        }
        request.setValue("Basic \(auth)", forHTTPHeaderField: "Authorization")
        
        do {
            let data = try await URLSession.shared.data(for: request)
            print("Received refresh token.")
            let response = try JSONDecoder().decode(AuthResponse.self, from: data.0)
        
            // Cache the token and return.
            self.cacheToken(response: response)
        } catch {
            throw AuthError.network("Fetching failed")
        }
    }
    
    private func cacheToken(response: AuthResponse) {
        print("Storing auth response\n\(response)\n")
        
        UserDefaults.standard.setValue(response.access_token, forKey: Keys.ACCESS_TOKEN)
        UserDefaults.standard.setValue(Date().addingTimeInterval(TimeInterval(response.expires_in)), forKey: Keys.EXPIRATION)
        if let refresh_token = response.refresh_token {
            // Only refresh if available.
            UserDefaults.standard.setValue(refresh_token, forKey: Keys.REFRESH_TOKEN)
        }
    }
    
    func accessTokenAsync() async -> String? {
        do {
            try await self.refreshIfNeeded()
            return UserDefaults.standard.string(forKey: Keys.ACCESS_TOKEN)
        } catch {
            print("Failed to aquire access token")
            return nil
        }
    }
    
    private var refreshToken: String? {
        return UserDefaults.standard.string(forKey: Keys.REFRESH_TOKEN)
    }
    
    private var tokenExpirationDate: Date? {
        return UserDefaults.standard.object(forKey: Keys.EXPIRATION) as? Date
    }
    
    private var shouldRefresh: Bool {
        guard let expirationDate = tokenExpirationDate else {
            return false
        }
        
        let currentDate = Date()
        let fiveMins: TimeInterval = 300
        return currentDate.addingTimeInterval(fiveMins) >= expirationDate
    }
}
