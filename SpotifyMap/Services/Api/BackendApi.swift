import Foundation

// TODO: Move structs to own separate file?
struct Songs: Codable {
    let href: String
    let items: [Song]
}

struct Song: Codable {
    let name: String
    let id: String
    let artists: [Artist]
    let album: Album
}

struct Album: Codable {
    let name: String
    let images: [AlbumImage]
}

struct Artist: Codable {
    let name: String
}

struct AlbumImage: Codable {
    let height: Int
    let width: Int
    let url: String
}

func getSearchSongs(search: String) {
    if (search.isEmpty){
        return print("empty")
    } else {
    let backendUrl = URL(string: "http://10.114.34.4/app/songs/search/\(search)")!
    let task = URLSession.shared.dataTask(with: backendUrl){ (data, respone, error) in
        guard let data = data else {
            return
        }
        let response = String(data: data, encoding: .utf8)!
        let jsonData = response.data(using: .utf8)!
        // Convert the JSON object to a Songs object
        let songs: Songs = try! JSONDecoder().decode(Songs.self, from: jsonData)
        print(songs)
    }
    task.resume()
    }
}
