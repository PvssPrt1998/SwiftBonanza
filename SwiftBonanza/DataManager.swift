import SwiftUI
import FirebaseDatabase
import AVKit

enum PlayerState {
    case play
    case pause
}

final class DataManager: ObservableObject {
    
    let localStorage = LocalStorage()
    
    var player: AVPlayer?
    
    var policy: String?
    var api: String?

    @Published var radioWaves: Dictionary<Int,StationShort> = [:]
    @Published var genres: Dictionary<Int,String> = [:]
    @Published var albums: Array<Album> = []
    
    @Published var playingWaveData: StationShort?
    
    @Published var loaded = false
    
    @Published var playerState: PlayerState = .pause
    
    @AppStorage("firstLaunch") var firstLaunch = true
    
    private var localLoaded = false {didSet {checkLoaded()}}
    private var remoteLoaded = false {didSet {checkLoaded()}}
    
    func loadLocalData(completion: @escaping () -> Void) {
        DispatchQueue.global(qos: .utility).async { [weak self] in
            guard let self = self else { return }
            
            if firstLaunch {
                if let image = UIImage(named: ImageTitles.favourite.rawValue)?.pngData() {
                    localStorage.save(album: Album(image: image, title: "Favourite", wavesIdArray: []))
                } else {
                    localStorage.save(album: Album(title: "Favourite", wavesIdArray: []))
                }
                
                localStorage.save(album: Album(title: "History", wavesIdArray: []))
                firstLaunch = false
            }
            
            if let albums = try? localStorage.fetchAlbums() {
                self.albums = albums
            }
            
            if let waves = try? localStorage.fetchWaves() {
                radioWaves = waves
            }
            if let genres = try? localStorage.fetchGenres() {
                genres.forEach { genre in
                    self.genres.updateValue(genre.name, forKey: Int(genre.id))
                }
            }
            
            DispatchQueue.main.async {
                self.localLoaded = true
                completion()
            }
        }
    }
    
    var ref: DatabaseReference!
    
    func loadDataFromFirebase(completion: @escaping () -> Void) {
        loadLinkFromFirebase { [weak self] in
            self?.loadPolicyFromFirebase {
                completion()
            }
        }
    }
    
    func loadPolicyFromFirebase(completion: @escaping () -> Void) {
        ref = Database.database().reference()
        ref.child("termsLink").observeSingleEvent(of: .value, with: { snapshot in
          // Get user value
          let value = snapshot.value as? String
            if let value = value {
                self.policy = value
            }
            completion()
        }) { error in
            completion()
          print(error.localizedDescription)
        }
    }
    
    func loadLinkFromFirebase(completion: @escaping () -> Void) {
        
        ref = Database.database().reference()
        ref.child("apiLink").observeSingleEvent(of: .value, with: { snapshot in
          // Get user value
          let value = snapshot.value as? String
            if let value = value {
                self.api = value
            }
            completion()
        }) { error in
            completion()
          print(error.localizedDescription)
        }
    }
    
    func save(album: Album) {
        localStorage.save(album: album)
    }
    
    func loadData() {
        loadLocalData { [weak self] in
            guard let self = self else { return }
            if self.radioWaves.count < 30 {
                self.loadRemote()
            } else {
                self.remoteLoaded = true
            }
        }
    }
    
    func loadRemote() {
        loadChannels(page: 1) { [weak self] in
            self?.loadChannels(page: 2) { [weak self] in
                self?.loadChannels(page: 3) { [weak self] in
                    self?.loadChannels(page: 4) { [weak self] in
                        self?.remoteLoaded = true
                    }
                }
            }
        }
    }
    
    func loadChannels(page: Int, completion: @escaping () -> Void) {
        let headers = [
            "x-rapidapi-key": "da4bf85998mshf454235b59456dep1eb73ejsn4c1f17535515",
            "x-rapidapi-host": "50k-radio-stations.p.rapidapi.com"
        ]

        var apiString = api ?? "https://50k-radio-stations.p.rapidapi.com/get/channels?page="
        apiString += "\(page)"
        let request = NSMutableURLRequest(url: NSURL(string: apiString)! as URL)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                self.remoteLoaded = true
                print(error as Any)
            } else {
                if let data = data {
                    if let station = try? JSONDecoder().decode(Station.self, from: data) {
                        self.saveData(station: station)
                        completion()
                    } else {
                        self.remoteLoaded = true
                    }
                }
            }
        })

        dataTask.resume()
    }
    
    private func checkLoaded() {
        if localLoaded && remoteLoaded {
            loaded = true
        }
    }
    
    func addToFavourite(id: Int) {
        guard let index = albums.firstIndex(where: {$0.title == "Favourite"}) else { return }
        if !albums[index].wavesIdArray.contains(id) {
            albums[index].wavesIdArray.insert(id)
            localStorage.save(album: albums[index])
        } else {
            albums[index].wavesIdArray.remove(id)
            localStorage.save(album: albums[index])
        }
        
    }
    
    func saveData(station: Station) { //TODO: -SAVE DATA PROBLEM
       station.data.forEach { data in
           if data.httpsURL.count > 0 {
               //print(data.httpsURL[0])
                   let genreArray: Array<Genre> = data.genre
                   var genreIds: Array<Int32> = []
                   var genreIdsInt: Array<Int> = []
                   genreArray.forEach { genre in
                       if !self.genres.keys.contains(genre.id) {
                           localStorage.createOrEditGenre(id: genre.id, name: genre.name)
                       }
                       self.genres.updateValue(genre.name, forKey: genre.id)
                       genreIds.append(Int32(genre.id))
                       genreIdsInt.append(genre.id)
                   }
                   if radioWaves.keys.contains(data.id) && radioWaves[data.id] != nil {
                       var stationShort = radioWaves[data.id]!
                       stationShort.imageUrl = data.logo.size150X150
                       stationShort.title = data.name
                       stationShort.url = data.httpsURL[0].url
                       stationShort.genreIdArray = genreIdsInt
                       radioWaves.updateValue(stationShort, forKey: stationShort.id)
                       localStorage.editWaveDataObject(station: stationShort)
                   } else {
                       let stationShort = StationShort(imageUrl: data.logo.size150X150, title: data.name, url: data.httpsURL[0].url, id: data.id, genreIdArray: genreIdsInt, isFavourite: false)
                       radioWaves.updateValue(stationShort, forKey: stationShort.id)
                       localStorage.createWaveDataObject(station: stationShort)
                   }
           }
        }
        localStorage.saveContext()
    }
    
    private func isUrlIPType(urlStr: String) -> Bool {
        let array = urlStr.components(separatedBy: ".")
        if array.count > 2 {
            return true
        } else {
            return false
        }
    }
    
    func getGenresArray() -> [String] {
        var array: Array<String> = []
        genres.forEach { (key, value) in
            array.append(value)
        }
        return array
    }
    
    func getWaves() -> [StationShort] {
        var array: Array<StationShort> = []
        radioWaves.forEach { (key, value) in
            array.append(value)
        }
        return array
    }
    
    func setSelectedData(id: Int) {
        guard let wave = radioWaves[id] else { return }
        playingWaveData = wave
        let url  = URL.init(string: wave.url)
        guard let url = url else { return }
        let playerItem: AVPlayerItem = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: playerItem)
        if let historyIndex = albums.firstIndex(where: {$0.title == "History"}) {
            albums[historyIndex].wavesIdArray.insert(id)
            localStorage.save(album: albums[historyIndex])
        }
            
        play()
    }
    
    func play() {
        guard let player = player else { return }
        playerState = .play
        player.play()
    }
    
    func pause() {
        guard let player = player else { return }
        playerState = .pause
        player.pause()
    }
    
    func deselectStation() {
        playingWaveData = nil
        playerState = .pause
        self.player = nil
    }
}
