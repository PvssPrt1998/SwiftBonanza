
import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var viewModelFactory: ViewModelFactory
    
    @Binding var tabSelection: Int
    @ObservedObject var viewModel: HomeViewModel
    
    init(selection: Binding<Int>, viewModel: HomeViewModel) {
        self._tabSelection = selection
        self.viewModel = viewModel
        
        UIScrollView.appearance().bounces = true
    }
    
    var radioListView: some View {
        VStack(spacing: 0) {
            HStack(spacing: 2) {
                TextCustom(text: "Swiit bronanza", size: 17, weight: .semibold, color: .primaryPink)
                Image(ImageTitles.BronanzaLogo.rawValue)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 29, height: 32)
            }
            .padding(.top, 3)
            SearchTextField(text: $viewModel.searchText, placeholder: "Search")
                .padding(EdgeInsets(top: 1, leading: 16, bottom: 15, trailing: 16))
            
            if viewModel.searchText != "" {
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVStack(spacing: 8) {
                        ForEach(viewModel.filtered, id: \.self) { title in
                            TextCustom(text: title, size: 17, weight: .regular, color: .black)
                                .lineLimit(1)
                                .padding(.horizontal, 16)
                                .frame(maxWidth: .infinity ,alignment: .leading)
                                .onTapGesture {
                                    viewModel.selectSearchRow(title)
                                }
                        }
                    }
                }
                
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 0) {
                        Button {
                            viewModel.resetFilter()
                        } label: {
                            TextCustom(text: "All", size: 12, weight: .regular)
                                .padding(.horizontal, 4)
                                .frame(minWidth: 50, maxHeight: .infinity)
                                .background(Color.primaryPink)
                                .clipShape(.rect(cornerRadius: 23))
                        }
                        .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 10))
                        LazyHStack(spacing: 10) {
                            ForEach(0..<viewModel.genres.count, id: \.self) { index in
                                    Button {
                                        viewModel.filterByGenre(index: index)
                                    } label: {
                                        TextCustom(text: viewModel.genres[index], size: 12, weight: .regular)
                                            .padding(.horizontal, 4)
                                            .frame(minWidth: 50, maxHeight: .infinity)
                                            .background(Color.primaryPink)
                                            .clipShape(.rect(cornerRadius: 23))
                                    }
                            }
                        }
                        .padding(.trailing, 16)
                    }
                }
                .frame(height: 28)
                
                TextCustom(text: "Radio waves", size: 28, weight: .bold, color: .black)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(EdgeInsets(top: 0, leading: 16, bottom: 20, trailing: 16))
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVStack(spacing: 8) {
                        ForEach(0..<viewModel.waves.count, id: \.self) { index in
                            RadioWaveSmallView(playing: viewModel.isPlaying(index: index), isFavourite: viewModel.isFavourite(by: index), wave: viewModel.waves[index]) {
                                viewModel.setPlayingWave(id: viewModel.waves[index].id)
                            } addToFavouriteAction: {
                                viewModel.addToFavourite(id: viewModel.waves[index].id)
                            }
                        }
                    }
                }
                .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
            }
        }
        .frame(maxHeight: .infinity, alignment: .top)
    }
    
    var body: some View {
        ZStack {
            radioListView
            if viewModel.isWaveSelected() {
                StationView(viewModel: viewModelFactory.makeStationViewModel()) {
                    tabSelection += 1
                }
            }
        }
    }
}


struct HomeView_Preview: PreviewProvider {
    
    @State static var selection: Int = 0
    
    static var previews: some View {
        HomeView(selection: $selection, viewModel: HomeViewModel(dataManager: DataManager()))
    }
    
}
