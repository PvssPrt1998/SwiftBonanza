
import SwiftUI

struct ItemMainView: View {
    
    var imageTitle: String
    var text: String
    
    var body: some View {
        VStack(spacing: 0) {
            TabViewImage(systemName: imageTitle)
                .fontCustom(size: 18, weight: .medium)
            Spacer()
            Text(text)
                .font(.system(size: 10,weight: .medium))
        }
        .frame(height: 40)
    }
}

import SwiftUI

struct TabViewImage: View {
    
    let systemName: String
    
    var body: some View {
        if #available(iOS 15.0, *) {
            Image(systemName: systemName)
                .environment(\.symbolVariants, .none)
        } else {
            Image(systemName: systemName)
        }
    }
    
}

#Preview {
    TabViewImage(systemName: "Home")
}

