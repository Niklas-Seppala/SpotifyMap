import Foundation

// TODO: Move structs to own separate file?
struct Songs: Codable {
    let href: String
    let items: [Song]
}

struct Song: Codable, Identifiable {
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

func getSearchSongs(search: String, finished: @escaping ([Song]) -> Void) {
    
    if (search.isEmpty || search.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty){
        finished([])
    } else {
        
        let url = search.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        let backendUrl = URL(string: ("http://10.114.34.4/app/songs/search/\(url ?? "no")"))!
        
        let task = URLSession.shared.dataTask(with: backendUrl){ (data, respone, error) in
            
            guard let data = data else {
                finished([])
                return
            }
            let response = String(data: data, encoding: .utf8)!
            let jsonData = response.data(using: .utf8)!
            // Convert the JSON object to a Songs object
            let songs: Songs = try! JSONDecoder().decode(Songs.self, from: jsonData)
            finished(songs.items)
        }
        task.resume()
    }
}
struct GenericApiResponse: Codable {
    let msg: String
}

func addSongToLocation(locationId: Int, spotifySongId: String, finished: @escaping (_ response: GenericApiResponse) -> Void) {
    
    if (spotifySongId.isEmpty){
        return
    } else {
        
        let backendUrl = URL(string: ("http://10.114.34.4/app/location/\(locationId)/songs/\(spotifySongId)"))!
        var request = URLRequest(url: backendUrl)
        request.httpMethod = "POST"
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, respone, error) in
            
            guard let data = data else {
                return
            }
            
            let jsonData = String(data: data, encoding: .utf8)!.data(using: .utf8)!
            let response: GenericApiResponse = try! JSONDecoder().decode(GenericApiResponse.self, from: jsonData)
            
            finished(response)
        })
        task.resume()
    }
}
