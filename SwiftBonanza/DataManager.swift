import SwiftUI
import AVKit

enum PlayerState {
    case play
    case pause
}

final class DataManager: ObservableObject {
    
    let localStorage = LocalStorage()
    
    var player: AVPlayer?

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
                localStorage.save(album: Album(title: "Favourite", wavesIdArray: []))
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
    
    func loadData() {
        loadLocalData { [weak self] in
            guard let self = self else { return }
            if self.radioWaves.count < 60 {
                self.loadRemote()
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

        let request = NSMutableURLRequest(url: NSURL(string: "https://50k-radio-stations.p.rapidapi.com/get/channels?page=\(page)")! as URL)
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
            albums[index].wavesIdArray.append(id)
            localStorage.save(album: albums[index])
        }
        
    }
    
    func saveData(station: Station) { //TODO: -SAVE DATA PROBLEM
       station.data.forEach { data in
           if data.httpsURL.count > 0 {
               if !isUrlIPType(urlStr: data.httpsURL[0].url) {
                   print(data.httpsURL[0].url)
                   let genreArray: Array<Genre> = data.genre
                   var genreIds: Array<Int32> = []
                   var genreIdsInt: Array<Int> = []
                   genreArray.forEach { genre in
                       localStorage.createOrEditGenre(id: genre.id, name: genre.name)
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
        print(url)
        guard let url = url else { return }
        let playerItem: AVPlayerItem = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: playerItem)
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
        guard let player = player else { return }
        playerState = .pause
        self.player = nil
    }
}
