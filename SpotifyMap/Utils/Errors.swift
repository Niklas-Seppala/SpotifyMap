import Foundation

enum AuthError: Error {
    case invalidURL(String)
    case missingCache(String)
    case network(String)
}

enum SpotifyError: Error {
    case failedToFavourite(String)
}
