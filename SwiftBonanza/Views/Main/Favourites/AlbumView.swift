import SwiftUI

struct AlbumView: View {
    
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            ZStack {
                TextCustom(text: title, size: 17, weight: .semibold, color: .white)
                    .padding(EdgeInsets(top: 19, leading: 18, bottom: 19, trailing: 18))
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
            }
            .background(Color.primaryPink)
            .clipShape(.rect(cornerRadius: 18))
            .frame(maxWidth: .infinity, maxHeight: 124)
        }
    }
}

#Preview {
    AlbumView(title: "Favourites") {
        
    }
}
