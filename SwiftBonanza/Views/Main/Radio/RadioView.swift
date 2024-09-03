import SwiftUI

struct RadioView: View {
    
    @ObservedObject var viewModel: RadioViewModel
    
    @ObservedObject var imageLoader: ImageLoader
    @State var image: UIImage = UIImage()
    
    @State var searchText = ""
    
    init(viewModel: RadioViewModel) {
        self.viewModel = viewModel
        UISlider.appearance().tintColor = UIColor(Color.primaryPink)
        if viewModel.isWaveSelected {
            imageLoader = ImageLoader(urlString: viewModel.selectedWave!.imageUrl)
        } else {
            imageLoader = ImageLoader(urlString: "invalidUrl")
        }
    }
    
    var similiarWaves: some View {
        VStack(spacing: 0) {
            TextCustom(text: "Similar radio waves", size: 28, weight: .bold, color: .black)
                .padding(.vertical, 20)
                .frame(maxWidth: .infinity, alignment: .leading)
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack(spacing: 8) {
                    ForEach(0..<20, id: \.self) { index in
                        //RadioWaveSmallView(wave: <#WaveData#>)
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
            SearchTextField(text: $searchText, placeholder: "Search")
                .foregroundColorCustom(.primaryPink)
                .padding(EdgeInsets(top: 1, leading: 0, bottom: 15, trailing: 0))
            VStack {
                if viewModel.isWaveSelected {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 246, height: 125)
                        .onReceive(imageLoader.didChange) { data in
                            self.image = UIImage(data: data) ?? UIImage()
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
            if viewModel.isWaveSelected {
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
