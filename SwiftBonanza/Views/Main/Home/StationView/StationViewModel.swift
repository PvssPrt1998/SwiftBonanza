import Foundation

final class StationViewModel: ObservableObject {
    
    let dataManager: DataManager
    
    var station: StationShort? {
        dataManager.playingWaveData
    }
    
    init(dataManager: DataManager) {
        self.dataManager = dataManager
    }
    
    func isPlaying() -> Bool {
        if dataManager.playerState == .play {
            return true
        } else {
            return false
        }
    }
    
    func playerAction() {
        if dataManager.playingWaveData != nil {
            if dataManager.playerState == .pause {
                dataManager.play()
            } else {
                dataManager.pause()
            }
        }
    }
    
    func deselectWave() {
        dataManager.deselectStation()
    }
}
