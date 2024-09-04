import SwiftUI

struct AlbumWave: View {
    
    @ObservedObject var imageLoader: ImageLoader
    @State var image: UIImage = UIImage()

    let isAddedToAlbum: Bool
    let wave: StationShort
    let action: () -> Void
    
    init(isAddedToAlbum: Bool, wave: StationShort, action: @escaping () -> Void) {
        self.isAddedToAlbum = isAddedToAlbum
        self.wave = wave
        self.action = action
        imageLoader = ImageLoader(urlString: wave.imageUrl)
    }
    
    var body: some View {
        HStack(spacing: 5) {
            ZStack {
                Image(uiImage: UIImage(data: imageLoader.data) ?? UIImage())
                    .resizable()
                    .scaledToFit()
            }
            .frame(width: 40, height: 40)
            .background(Color.white)
            .clipShape(.rect(cornerRadius: 10))
            .onTapGesture {
                action()
            }
            .padding(9)
            TextCustom(text: wave.title, size: 17, weight: .regular, color: .white)
                .padding()
            Spacer()
            Button {
                action()
            } label: {
                if isAddedToAlbum {
                    Image(systemName: "checkmark.square.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundColorCustom(.white)
                        .frame(width: 24, height: 24)
                        .clipShape(.rect(cornerRadius: 3))
                } else {
                    RoundedRectangle(cornerRadius: 3)
                        .stroke(.white, lineWidth: 1)
                        .frame(width: 24, height: 24)
                }
                
            }
            .padding(9)
        }
        .padding(EdgeInsets(top: 3, leading: 4, bottom: 3, trailing: 4))
        .background(Color.bgPink)
        .clipShape(.rect(cornerRadius: 14))
    }
}
