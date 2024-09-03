import Foundation
import Combine

final class LoadingViewModel: ObservableObject {
    
    let toNextScreen = PassthroughSubject<Bool, Never>()
    let dataManager: DataManager
    
    var loaded = false
    
    @Published var value: Double = 0
    
    private var loadedCancellable: AnyCancellable?
    
    init(dataManager: DataManager) {
        self.dataManager = dataManager
        
        loadedCancellable = dataManager.$loaded.sink { [weak self] value in
            if value {
                self?.loaded = true
                self?.loadIfneeded()
            }
        }
        loaded = false
    }
    
    func loadData() {
        dataManager.loadData()
    }
    
    func stroke() {
        if value < 1 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.02) {
                self.value += 0.02
                self.stroke()
            }
        } else {
            loadIfneeded()
        }
    }
    
    private func loadIfneeded() {
        if value >= 1 && loaded {
            toNextScreen.send(true)
        }
    }
    
    
    
}
