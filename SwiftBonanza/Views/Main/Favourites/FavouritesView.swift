import SwiftUI

struct FavouritesView: View {
    
    @EnvironmentObject var viewModelFactory: ViewModelFactory
    @ObservedObject var viewModel: FavouriteViewModel
    
    @State var searchText = ""
    @State var showAlbumListView = false
    
    @State var isAddAlbumSizeLarge = false
    
    let columns: [GridItem] = Array(repeating: .init(.flexible(), spacing: 8), count: 2)
    
    var albumsView: some View {
        LazyVGrid(columns: columns, spacing: 8) {
            ForEach(2..<viewModel.albums.count, id: \.self) { index in
                AlbumView(title: viewModel.albums[index].title, imageData: viewModel.albums[index].image) {
                    viewModel.albumTitle = viewModel.albums[index].title
                    withAnimation {
                        showAlbumListView = true
                    }
                }
            }
        }
    }
    
    var constantAlbumsView: some View {
        ZStack {
            HStack(spacing: 8) {
                Button {
                    viewModel.albumTitle = viewModel.albums[0].title
                    withAnimation {
                        showAlbumListView = true
                    }
                } label: {
                    ZStack {
                        TextCustom(text: "Favourites", size: 17, weight: .semibold, color: .white)
                            .padding(EdgeInsets(top: 19, leading: 18, bottom: 19, trailing: 18))
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
                    }
                    .background(Color.primaryPink)
                    .clipShape(.rect(cornerRadius: 18))
                    .frame(maxWidth: .infinity, maxHeight: 175)
                }
                
                Rectangle()
                    .frame(width: 176, height: 175)
                    .hidden()
            }
            .frame(maxHeight: .infinity, alignment: .top)
            ZStack {
                if !isAddAlbumSizeLarge {
                    TextCustom(text: "Create an album", size: 17, weight: .semibold, color: .white)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                        .padding(10)
                } else {
                    HStack(spacing: 8) {
                        ZStack {
                            ImageView(imageData: $viewModel.imageData)
                        }
                        .frame(width: 72, height: 72)
                        //.background(Color.white.opacity(0.11))
                        .clipShape(.rect(cornerRadius: 12))
                        ZStack {
                            TextFieldCustom(text: $viewModel.addAlbumText, placeholder: "Title")
                                .padding(.leading, 16)
                        }
                        .frame(maxWidth: .infinity, maxHeight: 72)
                        .background(Color.white.opacity(0.11))
                        .clipShape(.rect(cornerRadius: 12))
                    }
                    .padding(18)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                }
                Button {
                    withAnimation {
                        if isAddAlbumSizeLarge {
                            viewModel.addAlbum()
                            viewModel.addAlbumText = ""
                            viewModel.imageData = nil
                            isAddAlbumSizeLarge = false
                        } else {
                            isAddAlbumSizeLarge = true
                        }
                    }
                } label: {
                    Image(systemName: "plus")
                        .resizable()
                        .scaledToFit()
                        .foregroundColorCustom(.primaryPink)
                        .padding(14)
                        .frame(width: 50, height: 50)
                        .background(viewModel.isAddButtonActive || !isAddAlbumSizeLarge ? Color.white : Color.white.opacity(0.4))
                        .clipShape(.rect(cornerRadius: 500))
                }
                .disabled(!viewModel.isAddButtonActive && isAddAlbumSizeLarge)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                .padding(10)
            }
            .frame(maxWidth: isAddAlbumSizeLarge ? .infinity : 176, maxHeight: isAddAlbumSizeLarge ? .infinity : 175)
            .background(Color.primaryPink)
            .clipShape(.rect(cornerRadius: 18))
            .frame(maxHeight: .infinity, alignment: .top)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
        }
    }
    
    var mainContent: some View {
        VStack(spacing: 0) {
            //ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 0) {
                    TextCustom(text: "Albums", size: 28, weight: .bold, color: .black)
                        .padding(.bottom, 20)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    ScrollView(.vertical, showsIndicators: false) {
                        constantAlbumsView
                            .frame(height: 175)
                        albumsView
                            .padding(.top, 8)
                    }
                    .clipShape(.rect(cornerRadius: 18))
                    TextCustom(text: "Radio", size: 28, weight: .bold, color: .black)
                        .padding(.vertical, 10)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    ScrollView(.vertical, showsIndicators: false) {
                        LazyVStack(spacing: 8) {
                            ForEach(0..<viewModel.albums.count, id: \.self) { index in
                                ExpandableAlbumView(album: viewModel.albums[index], viewModel: viewModelFactory.makeExpandableAlbumViewModel())
                            }
                        }
                        .clipShape(.rect(cornerRadius: 14))
                    }
                    .clipShape(.rect(cornerRadius: 14))
                }
            //}
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
            
            if showAlbumListView {
                AlbumAddListView(viewModel: viewModelFactory.makeAlbumAddListViewModel(), albumTitle: viewModel.albumTitle) {
                    withAnimation {
                        showAlbumListView = false
                    }
                }
            } else {
                mainContent
            }
        }
        .padding(.horizontal, 16)
        .frame(maxHeight: .infinity, alignment: .top)
    }
}

#Preview {
    FavouritesView(viewModel: FavouriteViewModel(dataManager: DataManager()))
        .environmentObject(ViewModelFactory(dataManager: DataManager()))
}
