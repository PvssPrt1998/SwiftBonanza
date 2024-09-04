import SwiftUI
import Combine

struct AlbumAddListView: View {
    
    @ObservedObject var viewModel: AlbumAddListViewModel
    
    let albumTitle: String
    let closeAction: () -> Void
    
    var body: some View {
        ZStack {
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack(spacing: 8) {
                    ForEach(0..<viewModel.waves.count, id: \.self) { index in
                        AlbumWave(isAddedToAlbum: viewModel.isAddedToAlbum(albumTitle, index: index), wave: viewModel.waves[index]) {
                            viewModel.action(albumTitle, index: index)
                        }
                    }
                }
                .padding(.top, 38)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            }
            
            
            Button {
                closeAction()
            } label: {
                Image(systemName: "xmark")
                    .resizable()
                    .scaledToFit()
                    .foregroundColorCustom(.white)
                    .padding(4)
                    .frame(width: 24, height: 24)
                    .background(Color.bgPink)
                    .clipShape(Circle())
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
            .padding(6)
        }
        
        .background(Color.white)
    }
}

#Preview {
    AlbumAddListView(viewModel: AlbumAddListViewModel(dataManager: DataManager()), albumTitle: "Favourites", closeAction: {})
}

final class AlbumAddListViewModel: ObservableObject {
    
    let dataManager: DataManager
    let waves: Array<StationShort>
    
    private var albumCancellable: AnyCancellable?
    
    init(dataManager: DataManager) {
        self.dataManager = dataManager
        self.waves = dataManager.getWaves()
        
        albumCancellable = dataManager.$albums.sink { [weak self] _ in
            self?.objectWillChange.send()
        }
    }
    
    func action(_ title: String, index: Int) {
        if isAddedToAlbum(title, index: index) {
            if let albumIndex = dataManager.albums.firstIndex(where: {$0.title == title}) {
                dataManager.albums[albumIndex].wavesIdArray.remove(waves[index].id)
                dataManager.save(album: dataManager.albums[albumIndex])
            }
        } else {
            if let albumIndex = dataManager.albums.firstIndex(where: {$0.title == title}) {
                dataManager.albums[albumIndex].wavesIdArray.insert(waves[index].id)
                dataManager.save(album: dataManager.albums[albumIndex])
            }
        }
    }
    
    func isAddedToAlbum(_ title: String, index: Int) -> Bool {
        if let album = dataManager.albums.first(where: {$0.title == title}) {
            if album.wavesIdArray.contains(waves[index].id) {
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }
    
}
