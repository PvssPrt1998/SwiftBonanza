import Foundation
import Combine

final class HomeViewModel: ObservableObject {
    
    @Published var dataManager: DataManager
    @Published var selectedIndexGenre: Int? = 0
    
    var genres: Array<String>
    var waves: Array<StationShort>
    
    @Published var playerState: PlayerState
    
    private var playerStateCancellable: AnyCancellable?
    
    init(dataManager: DataManager) {
        self.dataManager = dataManager
        self.playerState = dataManager.playerState
        genres = dataManager.getGenresArray()
        waves = dataManager.getWaves()
        
        playerStateCancellable = dataManager.$playerState.sink { [weak self] value in
            self?.playerState = value
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
}
