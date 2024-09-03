import SwiftUI

struct StationView: View {
    
    @ObservedObject var viewModel: StationViewModel
    
    @ObservedObject var imageLoader: ImageLoader
    @State var image: UIImage = UIImage()
    
    let action: () -> Void
    
    init(viewModel: StationViewModel, action: @escaping () -> Void) {
        self.viewModel = viewModel
        self.action = action
        self.imageLoader = ImageLoader(urlString: viewModel.station!.imageUrl)
    }
    
    var body: some View {
        HStack(spacing: 0) {
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
            }
            .frame(width: 40, height: 40)
            .onTapGesture {
                viewModel.playerAction()
            }
            if viewModel.station != nil {
                TextCustom(text: viewModel.station!.title, size: 17, weight: .regular, color: .c1821821821)
                    .lineLimit(1)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            
            Button {
                viewModel.deselectWave()
            } label: {
                Image(systemName: "xmark")
                    .resizable()
                    .scaledToFit()
                    .foregroundColorCustom(.bgPink)
                    .padding(7)
                    .frame(width: 24, height: 24)
                    .background(Color.bgOrange)
                    .clipShape(.circle)
            }
        }
        .padding(EdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 16))
        .background(Color.white)
        .onTapGesture {
            print("lel")
            action()
        }
        .frame(maxHeight: .infinity, alignment: .bottom)
    }
    
    @ViewBuilder func playView() -> some View {
        if viewModel.isPlaying() {
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

#Preview {
    StationView(viewModel: StationViewModel(dataManager: DataManager())) {
        
    }
}
