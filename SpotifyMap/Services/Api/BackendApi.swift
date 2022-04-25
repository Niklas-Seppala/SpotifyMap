import Foundation





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

        print(response)
    }
    task.resume()
    }
}
