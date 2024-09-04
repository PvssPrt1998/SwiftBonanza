import Foundation
import Combine

final class HomeViewModel: ObservableObject {
    
    @Published var dataManager: DataManager
    @Published var selectedIndexGenre: Int? = 0
    
    var genres: Array<String>
    @Published var waves: Array<StationShort>
    
    var trie = Trie<String>()
    
    @Published var filtered: Array<String> = []
    @Published var searchText = "" {
        didSet {
            filter(with: searchText)
        }
    }
    
    @Published var playerState: PlayerState
    
    private var playerStateCancellable: AnyCancellable?
    private var favouriteCancellable: AnyCancellable?
    
    init(dataManager: DataManager) {
        self.dataManager = dataManager
        self.playerState = dataManager.playerState
        genres = dataManager.getGenresArray()
        waves = dataManager.getWaves()
        
        waves.forEach { station in
            trie.insert(station.title)
        }
        
        playerStateCancellable = dataManager.$playerState.sink { [weak self] value in
            self?.playerState = value
        }
        favouriteCancellable = dataManager.$albums.sink { [weak self] _ in
            self?.objectWillChange.send()
        }
    }
    
    func resetFilter() {
        waves = dataManager.getWaves()
    }
    
    func filterByGenre(index: Int) {
        let genreTitle = genres[index]
        var genreId = -1
        dataManager.genres.forEach({ (key, value) in
            if value == genreTitle {
                genreId = key
            }
        })
        
        if genreId >= 0 {
            waves = dataManager.getWaves().filter({ station in
                station.genreIdArray.contains(genreId)
            })
        }
        
    }
    
    func selectSearchRow(_ title: String) {
        var id = -1
        if let index = waves.firstIndex(where: {$0.title == title}) {
            id = waves[index].id
            if dataManager.radioWaves[id] != nil && dataManager.playingWaveData != nil {
                if dataManager.radioWaves[id]!.id == dataManager.playingWaveData!.id {
                    searchText = ""
                    if dataManager.playerState == .pause {
                        dataManager.play()
                    }
                }
            } else {
                searchText = ""
                dataManager.setSelectedData(id: id)
            }
        }
    }
    
    func setPlayingWave(id: Int) {
        if dataManager.radioWaves[id] != nil && dataManager.playingWaveData != nil {
            if dataManager.radioWaves[id]!.id == dataManager.playingWaveData!.id {
                if dataManager.playerState == .pause {
                    dataManager.play()
                } else {
                    dataManager.pause()
                }
            } else {
                dataManager.setSelectedData(id: id)
            }
        } else {
            dataManager.setSelectedData(id: id)
        }
    }
    
    func isFavourite(by index: Int) -> Bool {
        guard let indexFavourite = dataManager.albums.firstIndex(where: {$0.title == "Favourite"}) else { return false }
        return dataManager.albums[indexFavourite].wavesIdArray.contains(waves[index].id)
    }
    
    func isPlaying(index: Int) -> Bool {
        guard let selectedWave = dataManager.playingWaveData else { return false }
        if waves[index].id == selectedWave.id && dataManager.playerState == .play {
            return true
        } else {
            return false
        }
    }
    
    func isWaveSelected() -> Bool {
        dataManager.playingWaveData != nil
    }
    
    func addToFavourite(id: Int) {
        dataManager.addToFavourite(id: id)
    }
    
    func filter(with text: String) {
        if text != "" {
            filtered = trie.collections(startingWith: text)
        } else { filtered = [] }
    }
}
