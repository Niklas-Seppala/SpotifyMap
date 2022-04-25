import Foundation

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
