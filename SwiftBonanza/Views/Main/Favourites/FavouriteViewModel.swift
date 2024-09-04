
import Foundation
import Combine

final class FavouriteViewModel: ObservableObject {
    
    let dataManager: DataManager
    
    @Published var imageData: Data?
    
    @Published var addAlbumText = "" {
        didSet {
            if !albumTitleAlreadyExists() && addAlbumText != "" {
                isAddButtonActive = true
            } else {
                isAddButtonActive = false
            }
        }
    }
    
    var albumTitle: String = ""
    
    @Published var isAddButtonActive: Bool = false
    
    var albums: [Album] {
        dataManager.albums.filter { album in
            album.title != "Favourite" || album.title != "History"
        }
    }
    
    private var albumsCancellable: AnyCancellable?
    
    init(dataManager: DataManager) {
        self.dataManager = dataManager
        albumsCancellable = dataManager.$albums.sink { [weak self] _ in
            self?.objectWillChange.send()
        }
    }
    
    func albumTitleAlreadyExists() -> Bool {
        var result = false
        dataManager.albums.forEach ({ album in
            if album.title == addAlbumText {
                result = true
            }
        })
        return result
    }
    
    func addAlbum() {
        dataManager.albums.append(Album(image: imageData, title: addAlbumText, wavesIdArray: []))
        dataManager.save(album: Album(image: imageData, title: addAlbumText, wavesIdArray: []))
    }
}
