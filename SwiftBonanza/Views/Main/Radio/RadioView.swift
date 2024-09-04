import SwiftUI

struct RadioView: View {
    
    @ObservedObject var viewModel: RadioViewModel
    
    //@ObservedObject var imageLoader: ImageLoader
    @State var image: UIImage = UIImage()
    
    @State var searchText = ""
    
    init(viewModel: RadioViewModel) {
        self.viewModel = viewModel
        UISlider.appearance().tintColor = UIColor(Color.primaryPink)
    }
    
    var similiarWaves: some View {
        VStack(spacing: 0) {
            TextCustom(text: "Similar radio waves", size: 28, weight: .bold, color: .black)
                .padding(.vertical, 20)
                .frame(maxWidth: .infinity, alignment: .leading)
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack(spacing: 8) {
                    ForEach(viewModel.wavesByGenre(), id: \.self) { wave in
                        RadioWaveSmallView(playing: viewModel.isPlaying(wave: wave), isFavourite: viewModel.isFavourite(wave: wave), wave: wave) {
                            viewModel.setPlayingWave(id: wave.id)
                        } addToFavouriteAction: {
                            viewModel.addToFavourite(id: wave.id)
                        }
                    }
                }
                .clipShape(.rect(cornerRadius: 16))
            }
            .clipShape(.rect(cornerRadius: 16))
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 2) {
                TextCustom(text: "Swiit bronanza", size: 17, weight: .semibold, color: .primaryPink)
                Image(ImageTitles.BronanzaLogo.rawValue)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 29, height: 32)
            }
            .padding(.top, 3)
//            SearchTextField(text: $searchText, placeholder: "Search")
//                .foregroundColorCustom(.primaryPink)
                .padding(EdgeInsets(top: 1, leading: 0, bottom: 15, trailing: 0))
            VStack {
                if viewModel.selectedWave != nil {
                    VStack(spacing: 0) {
                        Image(uiImage: UIImage(data: viewModel.data) ?? UIImage())
                            .resizable()
                            .scaledToFit()
                            .frame(width: 246, height: 125)
                        HStack {
                            Button {
                                viewModel.soundDisableButton()
                            } label: {
                                Image(systemName: viewModel.isSoundEnabled ? "speaker.wave.2.fill" : "speaker.slash.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColorCustom(.c138138142)
                                    .frame(width: 24, height: 24)
                            }
                            TextCustom(text: viewModel.selectedWave!.title, size: 17, weight: .bold, color: .black)
                                .lineLimit(1)
                                .padding(10)
                                .frame(maxWidth: .infinity, alignment: .center)
                            Button {
                                viewModel.favouriteButtonPressed()
                            } label: {
                                Image(systemName: viewModel.isSelectedFavourite() ? "folder.fill.badge.minus" : "folder.fill.badge.plus")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColorCustom(.c138138142)
                                    .frame(width: 24, height: 24)
                            }
                        }
                    }
                } else {
                    Image(systemName: "wave.3.forward")
                        .resizable()
                        .scaledToFit()
                        .foregroundColorCustom(.primaryPink)
                        .rotationEffect(.degrees(-90))
                        .frame(height: 169)
                }
            }
            .frame(height: 203)
            Slider(value: $viewModel.sliderValue)
            Divider()
                .padding(.top, 8)
            if viewModel.selectedWave != nil {
                similiarWaves
            }
        }
        .padding(.horizontal, 16)
        .frame(maxHeight: .infinity, alignment: .top)
    }
}

#Preview {
    RadioView(viewModel: RadioViewModel(dataManager: DataManager()))
}
