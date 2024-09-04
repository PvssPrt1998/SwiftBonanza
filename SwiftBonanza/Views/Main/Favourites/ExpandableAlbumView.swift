import SwiftUI
import Combine

struct ExpandableAlbumView: View {
    
    let album: Album
    @ObservedObject var viewModel: ExpandableAlbumViewModel
    
    @State var expanded = false
    
    var body: some View {
        VStack(spacing: 10) {
            HStack {
                TextCustom(text: album.title, size: 28, weight: .bold, color: .white)
                    .padding(10)
                    .frame(maxWidth: .infinity, alignment: .leading)
                if !viewModel.isAlbumEmpty(album) {
                    Button {
                        withAnimation {
                            if expanded {
                                expanded = false
                            } else {
                                expanded = true
                            }
                        }
                    } label: {
                        Image(systemName: expanded ? "minus" : "plus")
                            .resizable()
                            .scaledToFit()
                            .foregroundColorCustom(.white)
                            .frame(width: 24, height: 24)
                    }
                    .padding(EdgeInsets(top: 3, leading: 4, bottom: 3, trailing: 4))
                }
            }
            if expanded && !viewModel.isAlbumEmpty(album) {
                LazyVStack(spacing: 10) {
                    ForEach(viewModel.getWaves(for: album), id: \.self) { wave in
                        ExpandedViewWaveElement(playing: viewModel.isPlaying(wave), wave: wave) {
                            viewModel.setPlayingWave(wave: wave)
                        } removeFromFavouriteAction: {
                            viewModel.removeFromAlbum(album, wave: wave)
                        }

                    }
                }
            }
        }
        .padding(EdgeInsets(top: 3, leading: 4, bottom: 3, trailing: 4))
        .background(Color.bgOrange)
        .clipShape(.rect(cornerRadius: 14))
    }
}

#Preview {
    ExpandableAlbumView(album: Album(title: "Album1", wavesIdArray: []), viewModel: ExpandableAlbumViewModel(dataManager: DataManager()))
}

final class ExpandableAlbumViewModel: ObservableObject {
    
    let dataManager: DataManager
    
    private var albumCancellable: AnyCancellable?
    
    var playingWave: StationShort? {
        dataManager.playingWaveData
    }
    
    private var playingCancellable: AnyCancellable?
    
    init(dataManager: DataManager) {
        self.dataManager = dataManager
        
        albumCancellable = dataManager.$albums.sink { [weak self] _ in
            self?.objectWillChange.send()
        }
        playingCancellable = dataManager.$playerState.sink { [weak self] _ in
            self?.objectWillChange.send()
        }
    }
    
    func isAlbumEmpty(_ album: Album) -> Bool {
        guard let album = dataManager.albums.first(where: {$0.title == album.title}) else { return true }
        if album.wavesIdArray.isEmpty {
            return true
        } else {
            return false
        }
    }
    
    func isPlaying(_ wave: StationShort) -> Bool {
        let result = false
        if let playingWave = playingWave {
            if playingWave.id == wave.id && dataManager.playerState == .play {
                return true
            }
        }
        return result
    }
    
    func setPlayingWave(wave: StationShort) {
        if dataManager.radioWaves[wave.id] != nil && dataManager.playingWaveData != nil {
            if dataManager.radioWaves[wave.id]!.id == dataManager.playingWaveData!.id {
                if dataManager.playerState == .pause {
                    dataManager.play()
                } else {
                    dataManager.pause()
                }
            } else {
                dataManager.setSelectedData(id: wave.id)
            }
        } else {
            dataManager.setSelectedData(id: wave.id)
        }
    }
    
    func getWaves(for album: Album) -> [StationShort] {
        var waves: Array<StationShort> = []
        album.wavesIdArray.forEach { id in
            if let wave = dataManager.radioWaves[id] {
                waves.append(wave)
            }
        }
        return waves
    }
    
    func removeFromAlbum(_ album: Album, wave: StationShort) {
        if let albumIndex = dataManager.albums.firstIndex(where: {$0.title == album.title}) {
            dataManager.albums[albumIndex].wavesIdArray.remove(wave.id)
            dataManager.save(album: dataManager.albums[albumIndex])
        }
    }
}
