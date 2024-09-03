import Foundation
import Combine

final class RadioViewModel: ObservableObject {
    
    let dataManager: DataManager
    
    @Published var sliderValue: Float = 0.5 {
        didSet {
           setVolumeLevel()
        }
    }
    
    var isWaveSelected: Bool {
        dataManager.playingWaveData != nil
    }
    
    var selectedWave: StationShort?
    
    private var waveCancellable: AnyCancellable?
    
    
    init(dataManager: DataManager) {
        self.dataManager = dataManager
        self.selectedWave = dataManager.playingWaveData
        waveCancellable = dataManager.$playingWaveData.sink { [weak self] value in
            self?.selectedWave = value
        }
    }
    
    func setVolumeLevel() {
        guard dataManager.player != nil else { return }
        dataManager.player!.volume = sliderValue
    }
}
