
import Foundation

final class ViewModelFactory: ObservableObject {
    
    let dataManager: DataManager
    
    init(dataManager: DataManager) {
        self.dataManager = dataManager
    }
    
    func makeLoadingViewModel() -> LoadingViewModel {
        LoadingViewModel(dataManager: dataManager)
    }
    
    func makeHomeViewModel() -> HomeViewModel {
        HomeViewModel(dataManager: dataManager)
    }
    
    func makeStationViewModel() -> StationViewModel {
        StationViewModel(dataManager: dataManager)
    }
    
    func makeRadioViewModel() -> RadioViewModel {
        RadioViewModel(dataManager: dataManager)
    }
    
    func makeFavouriteViewModel() -> FavouriteViewModel {
        FavouriteViewModel(dataManager: dataManager)
    }
}
