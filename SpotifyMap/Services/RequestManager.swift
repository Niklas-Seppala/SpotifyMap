import Foundation
import Combine
import SwiftUI

struct ServerMessage: Decodable {
    let res, message: String
}

struct LocationVariables {
    static var currentLocationId: Int = 0
}

struct FetchSingleSong: Codable, Hashable {
    let albumName: String?
    let albumThumb: String?
    let artist: String?
    let createdOn: String
    let id: Int
    let name: String
    let popularity: Int
    let spotifyID: String
    let updatedAt: String?
    
    enum CodingKeys: String, CodingKey {
        case albumName = "album_name"
        case albumThumb = "album_thumb"
        case createdOn = "created_on"
        case id, name, popularity, artist
        case spotifyID = "spotifyId"
        case updatedAt = "updated_at"
    }
}

struct FetchResponse: Codable {
    let createdOn: String
    let id: Int
    let name: String
    let songs: [FetchSingleSong]
    let updatedAt: String?
    
    enum CodingKeys: String, CodingKey {
        case createdOn = "created_on"
        case id, name, songs
        case updatedAt = "updated_at"
    }
}

class RequestManager: ObservableObject {
    @Published var isLoading = true
    @Published var songs = [FetchSingleSong]()
    @Published var err = false
    
    // Fetch songs from the backend  for HomeView and sort them by the newest first
    func getAreaSongs(area: String, completion: @escaping (HTTPURLResponse?, Error?) -> Void) {
        guard let url = URL(string: "http://10.114.34.4/app/app/location/\"\(area.replacingOccurrences(of: "ä", with: "a").replacingOccurrences(of: " ", with: "-"))\"".replacingOccurrences(of: "\"", with: "")) else {
            print("invalid url")
            DispatchQueue.main.async {
                self.isLoading = false
            }
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        DispatchQueue.main.async {
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                let httpResponse = response as? HTTPURLResponse;
                guard (error == nil && httpResponse?.statusCode == 200) else {
                    completion(httpResponse, error)
                    self.songs = []
                    DispatchQueue.main.async {
                        self.isLoading = false
                    }
                     return
                }
                guard let data = data else {
                    DispatchQueue.main.async {
                        self.isLoading = false
                    }
                    return
                }
                let response = try? JSONDecoder().decode(FetchResponse.self, from: data)
                DispatchQueue.main.async {
                    // Update the global variable (will be required for adding a song)
                    LocationVariables.currentLocationId = response?.id ?? 0
                    // Sort songs by newest
                    self.songs = response?.songs.sorted(by: { $0.id > $1.id }) ?? []
                    self.isLoading = false
                }
            }
            task.resume()
        }
    }
}
