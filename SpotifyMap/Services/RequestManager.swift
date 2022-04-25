import Foundation
import Combine
import SwiftUI

struct ServerMessage: Decodable {
    let res, message: String
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
    @Published var isLoading = false
    @Published var songs = [FetchSingleSong]()
    
    func getAreaSongs(area: String) {
        DispatchQueue.main.async {
            self.isLoading = true
        }
        guard let url = URL(string: "http://10.114.34.4/app/app/location/\"\(area.replacingOccurrences(of: "ä", with: "a"))\"".replacingOccurrences(of: "\"", with: "")) else {
            print("invalid url")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        DispatchQueue.main.async {
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                guard let data = data else {return}
                let response = try! JSONDecoder().decode(FetchResponse.self, from: data)
                DispatchQueue.main.async {
                    self.songs = response.songs
                }
            }.resume()
            self.isLoading = false
        }
    }
}