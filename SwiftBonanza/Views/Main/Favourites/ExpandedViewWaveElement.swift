import SwiftUI

struct ExpandedViewWaveElement: View {
    @ObservedObject var imageLoader: ImageLoader
    @State var image: UIImage = UIImage()
    
    @State var playPadding: CGFloat = 10
    
    let playing: Bool
    let wave: StationShort
    let action: () -> Void
    let removeFromFavouriteAction: () -> Void
    
    init(playing: Bool, wave: StationShort, action: @escaping () -> Void, removeFromFavouriteAction: @escaping () -> Void) {
        self.playing = playing
        self.wave = wave
        self.action = action
        self.removeFromFavouriteAction = removeFromFavouriteAction
        imageLoader = ImageLoader(urlString: wave.imageUrl)
    }
    
    var body: some View {
        HStack(spacing: 5) {
            ZStack {
                Image(uiImage: UIImage(data: imageLoader.data) ?? UIImage())
                    .resizable()
                    .scaledToFit()
                playView()
                    .shadow(radius: 2)
                    .padding(10)
                    .onAppear {
                        if playing {
                            withAnimation(.linear(duration: 1).repeatForever(autoreverses: true)) {
                                playPadding = 5
                            }
                        }
                    }
            }
            .frame(width: 40, height: 40)
            .background(Color.white)
            .clipShape(.rect(cornerRadius: 10))
            .onTapGesture {
                action()
            }
            .padding(9)
            TextCustom(text: wave.title, size: 17, weight: .regular, color: .specialSecondary)
                .lineLimit(1)
                .padding()
            Spacer()
            Button {
                removeFromFavouriteAction()
            } label: {
                Image(systemName: "folder.fill.badge.minus")
                    .resizable()
                    .scaledToFit()
                    .foregroundColorCustom(.primaryPink)
                    .frame(width: 24, height: 24)
            }
            .padding(9)
        }
        .padding(EdgeInsets(top: 3, leading: 4, bottom: 3, trailing: 4))
        .background(Color.white)
        .clipShape(.rect(cornerRadius: 14))
    }
    
    @ViewBuilder func playView() -> some View {
        if playing {
            Image(systemName: "pause.fill")
                .resizable()
                .scaledToFit()
                .foregroundColorCustom(.white)
        } else {
            Image(systemName: "play.fill")
                .resizable()
                .scaledToFit()
                .foregroundColorCustom(.white)
        }
    }
}

//#Preview {
//    ExpandedViewWaveElement(isPlaying: true, wave: Sta, action: <#() -> Void#>)
//}
