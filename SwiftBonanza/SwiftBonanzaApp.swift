import SwiftUI

@main
struct SwiftBonanzaApp: App {
    
    let dataManager: DataManager
    let viewModelFactory: ViewModelFactory
    
    @ObservedObject var appCoordinator: AppCoordinator
    
    init() {
        dataManager = DataManager()
        viewModelFactory = ViewModelFactory(dataManager: dataManager)
        appCoordinator = AppCoordinator(viewModelFactory: viewModelFactory)
    }
    
    var body: some Scene {
        WindowGroup {
            appCoordinator.build()
                .environmentObject(viewModelFactory)
        }
    }
}
