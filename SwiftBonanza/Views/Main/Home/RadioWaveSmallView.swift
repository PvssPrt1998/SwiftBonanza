import SwiftUI

struct RadioWaveSmallView: View {
    
    @ObservedObject var imageLoader: ImageLoader
    @State var image: UIImage = UIImage()
    
    @State var playPadding: CGFloat = 10
    
    let playing: Bool
    let wave: StationShort
    let action: () -> Void
    let addToFavouriteAction: () -> Void
    
    init(playing: Bool, wave: StationShort, action: @escaping () -> Void, addToFavouriteAction: @escaping () -> Void) {
        self.playing = playing
        self.wave = wave
        self.action = action
        self.addToFavouriteAction = addToFavouriteAction
        imageLoader = ImageLoader(urlString: wave.imageUrl)
    }
    
    var body: some View {
        HStack(spacing: 5) {
            ZStack {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .onReceive(imageLoader.didChange) { data in
                        self.image = UIImage(data: data) ?? UIImage()
                    }
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
            TextCustom(text: wave.title, size: 17, weight: .regular, color: .white)
                .padding()
            Spacer()
            Button {
                addToFavouriteAction()
            } label: {
                Image(systemName: "plus")
                    .resizable()
                    .scaledToFit()
                    .foregroundColorCustom(.white)
                    .frame(width: 24, height: 24)
            }
            .padding(9)
        }
        .padding(EdgeInsets(top: 3, leading: 4, bottom: 3, trailing: 4))
        .background(Color.bgPink)
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
//    RadioWaveSmallView(wave: Wave)
//}
