import SwiftUI
import AVKit

struct ContentView: View {
    
    @State var song1 = false
    @StateObject private var soundManager = SoundManager()
    let dataManager: DataManager = DataManager()
    
    var body: some View {
        VStack {
            Text("Hello, world!")
        }
        .padding()
        .onAppear {
//            soundManager.playSound(sound: "https://betelgeuse.dribbcast.com/proxy/asudai/stream/")
//            soundManager.audioPlayer?.play()
//            runSound()
            //countryRequest1()
            //countryRequest()
            //radioRequest()
        }
    }
    
    func runSound() {
        var player: AVPlayer!
        let url  = URL.init(string: "https://betelgeuse.dribbcast.com/proxy/asudai/stream/")

        let playerItem: AVPlayerItem = AVPlayerItem(url: url!)
        player = AVPlayer(playerItem: playerItem)

        let playerLayer = AVPlayerLayer(player: player!)
        player.play()
    }

//    func radioRequest() {
//        let headers = [
//            "x-rapidapi-key": "da4bf85998mshf454235b59456dep1eb73ejsn4c1f17535515",
//            "x-rapidapi-host": "radio-stations-fm-am-api.p.rapidapi.com"
//        ]
//
//        let request = NSMutableURLRequest(url: NSURL(string: "https://radio-stations-fm-am-api.p.rapidapi.com/UY/stations.json")! as URL,
//                                                cachePolicy: .useProtocolCachePolicy,
//                                            timeoutInterval: 10.0)
//        request.httpMethod = "GET"
//        request.allHTTPHeaderFields = headers
//
//        let session = URLSession.shared
//        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
//            if (error != nil) {
//                print(error as Any)
//            } else {
//                let httpResponse = response as? HTTPURLResponse
//                if let data = data {
//                    let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
//                    guard let stations = try? JSONDecoder().decode([Station].self, from: data) else { return }
//                    if stations.count > 0 {
//                        print(stations.first!.departemanto)
//                    }
//                }
//            }
//        })
//
//        dataTask.resume()
//    }
    
    
}

#Preview {
    ContentView()
}
