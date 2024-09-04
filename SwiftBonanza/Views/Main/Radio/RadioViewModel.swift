import Foundation
import Combine

final class RadioViewModel: ObservableObject {
    
    let dataManager: DataManager
    
    @Published var imageLoader: ImageLoader?
    @Published var sliderValue: Float = 0.5 {
        didSet {
           setVolumeLevel()
        }
    }
    
    @Published var data: Data = Data()
    
    @Published var selectedWave: StationShort?
    
    var isSoundEnabled: Bool {
        guard dataManager.player != nil else { return false}
        return dataManager.player!.volume > 0
    }
    
    private var waveCancellable: AnyCancellable?
    private var albumsCancellable: AnyCancellable?
    private var imageLoaderCancellable: AnyCancellable?
    
    
    init(dataManager: DataManager) {
        self.dataManager = dataManager
        self.selectedWave = dataManager.playingWaveData
        waveCancellable = dataManager.$playingWaveData.sink { [weak self] value in
            self?.selectedWave = value
            if value != nil {
                self?.imageLoader = ImageLoader(urlString: value!.imageUrl)
                self?.imageLoaderCancellable = self?.imageLoader?.$data.sink { [weak self] value in
                    self?.data = value
                }
            } else {
                self?.imageLoader = ImageLoader(urlString: "invalidStr")
                self?.imageLoaderCancellable = nil
            }
        }
        
        albumsCancellable = dataManager.$albums.sink { [weak self] _ in
            self?.objectWillChange.send()
        }
    }
    
    func wavesByGenre() -> [StationShort] {
        let stations: Array<StationShort> = []
        guard let genreIds = selectedWave?.genreIdArray else { return stations }
        return dataManager.getWaves().filter { station in
            var result = false
            genreIds.forEach { id in
                if station.genreIdArray.contains(id) {
                    result = true
                }
            }
            if selectedWave?.id == station.id { result = false }
            return result
        }
    }
    
    func addToFavourite(id: Int) {
        dataManager.addToFavourite(id: id)
    }
    
    func isPlaying(wave: StationShort) -> Bool {
        if dataManager.playingWaveData?.id == wave.id && dataManager.playerState == .play {
            return true
        } else {
            return false
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
    
    func isFavourite(wave: StationShort) -> Bool {
        guard let favIndex = dataManager.albums.firstIndex(where: {$0.title == "Favourite"}) else {return false}
        if dataManager.albums[favIndex].wavesIdArray.contains(wave.id) {
            return true
        } else {
            return false
        }
    }
    
    func setVolumeLevel() {
        guard dataManager.player != nil else { return }
        dataManager.player!.volume = sliderValue
    }
    
    func removeSound() {
        guard dataManager.player != nil else { return }
        dataManager.player!.volume = 0
    }
    
    func isSelectedFavourite() -> Bool {
        guard let indexFavourite = dataManager.albums.firstIndex(where: {$0.title == "Favourite"}) else { return false }
        guard selectedWave != nil else { return false }
        return dataManager.albums[indexFavourite].wavesIdArray.contains(selectedWave!.id)
    }
    
    func soundDisableButton() {
        guard dataManager.player != nil else { return }
        if dataManager.player!.volume > 0 {
            removeSound()
        } else {
            setVolumeLevel()
        }
    }
    
    func favouriteButtonPressed() {
        guard selectedWave != nil else { return }
        dataManager.addToFavourite(id: selectedWave!.id)
    }
}
