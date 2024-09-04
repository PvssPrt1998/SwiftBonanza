import SwiftUI
import FirebaseCore
import FirebaseDatabase

@main
struct SwiftBonanzaApp: App {
    
    let dataManager: DataManager
    
    let viewModelFactory: ViewModelFactory
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
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

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}
