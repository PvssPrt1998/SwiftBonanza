
import Foundation

final class FavouriteViewModel: ObservableObject {
    
    let dataManager: DataManager
    
    var albums: [Album] {
        dataManager.albums.filter { album in
            album.title != "Favourite" || album.title != "History"
        }
    }
    
    init(dataManager: DataManager) {
        self.dataManager = dataManager
    }
}
