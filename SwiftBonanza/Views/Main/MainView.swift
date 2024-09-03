
import SwiftUI
import UIKit

struct MainView: View {
    
    @State var selection = 0
    @EnvironmentObject var viewModelFactory: ViewModelFactory
    
    init() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.stackedLayoutAppearance.normal.iconColor = UIColor(rgbColorCodeRed: 238, green: 113, blue: 158, alpha: 0.56)
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(rgbColorCodeRed: 238, green: 113, blue: 158, alpha: 0.56)]

        appearance.stackedLayoutAppearance.selected.iconColor = UIColor(rgbColorCodeRed: 238, green: 113, blue: 158, alpha: 1)
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(rgbColorCodeRed: 238, green: 113, blue: 158, alpha: 1)]
        
        appearance.shadowColor = .white.withAlphaComponent(0.15)
        appearance.shadowImage = UIImage(named: "tab-shadow")?.withRenderingMode(.alwaysTemplate)
        UITabBar.appearance().standardAppearance = appearance
    }
    
    var body: some View {
        TabView(selection: $selection) {
            HomeView(selection: $selection, viewModel: viewModelFactory.makeHomeViewModel())
                .tabItem { ItemMainView(imageTitle: "house.fill", text: "Home") }
                .tag(0)
            RadioView(viewModel: viewModelFactory.makeRadioViewModel())
                .tabItem { ItemMainView(imageTitle: "dot.radiowaves.left.and.right", text: "Radio") }
                .tag(1)
            FavouritesView(viewModel: viewModelFactory.makeFavouriteViewModel())
                .tabItem { ItemMainView(imageTitle: "folder.fill", text: "Favourites") }
                .tag(2)
            SettingsView()
                .tabItem { ItemMainView(imageTitle: "gearshape.fill", text: "Settings") }
                .tag(3)
        }
    }
}

#Preview {
    MainView()
}

extension UIColor {
   convenience init(rgbColorCodeRed red: Int, green: Int, blue: Int, alpha: CGFloat) {

     let redPart: CGFloat = CGFloat(red) / 255
     let greenPart: CGFloat = CGFloat(green) / 255
     let bluePart: CGFloat = CGFloat(blue) / 255

     self.init(red: redPart, green: greenPart, blue: bluePart, alpha: alpha)
   }
}

extension UITabBarController {
    var height: CGFloat {
        return self.tabBar.frame.size.height
    }
    
    var width: CGFloat {
        return self.tabBar.frame.size.width
    }
}

