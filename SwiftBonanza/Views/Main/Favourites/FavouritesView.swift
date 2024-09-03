import SwiftUI

struct FavouritesView: View {
    
    @ObservedObject var viewModel: FavouriteViewModel
    
    @State var searchText = ""
    @State var addAlbumText = ""
    
    @State var isAddAlbumSizeLarge = false
    
    let columns: [GridItem] = Array(repeating: .init(.flexible(), spacing: 8), count: 2)
    
    var albumsView: some View {
        LazyVGrid(columns: columns, spacing: 8) {
            ForEach(viewModel.albums, id: \.self) { album in
                AlbumView(title: album.title) {
                    //
                }
            }
        }
    }
    
    var constantAlbumsView: some View {
        ZStack {
            HStack(spacing: 8) {
                ZStack {
                    TextCustom(text: "Favourites", size: 17, weight: .semibold, color: .white)
                        .padding(EdgeInsets(top: 19, leading: 18, bottom: 19, trailing: 18))
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
                }
                .background(Color.primaryPink)
                .clipShape(.rect(cornerRadius: 18))
                .frame(maxWidth: .infinity, maxHeight: 124)
                
                Rectangle()
                    .frame(width: 176, height: 124)
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
                            
                        }
                        .frame(width: 72, height: 72)
                        .background(Color.white.opacity(0.11))
                        .clipShape(.rect(cornerRadius: 12))
                        ZStack {
                            TextFieldCustom(text: $addAlbumText, placeholder: "Title")
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
                            addAlbumText = ""
                            isAddAlbumSizeLarge = false
                        } else {
                            isAddAlbumSizeLarge = true
                        }
                    }
                } label: {
                    Image(systemName: isAddAlbumSizeLarge ? "minus" : "plus")
                        .resizable()
                        .scaledToFit()
                        .foregroundColorCustom(.primaryPink)
                        .padding(14)
                        .frame(width: 50, height: 50)
                        .background(Color.white)
                        .clipShape(.rect(cornerRadius: 500))
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                .padding(10)
            }
            .frame(maxWidth: isAddAlbumSizeLarge ? .infinity : 176, maxHeight: isAddAlbumSizeLarge ? .infinity : 124)
            .background(Color.primaryPink)
            .clipShape(.rect(cornerRadius: 18))
            .frame(maxHeight: .infinity, alignment: .top)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
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
            TextCustom(text: "Albums", size: 28, weight: .bold, color: .black)
                .padding(.bottom, 20)
                .frame(maxWidth: .infinity, alignment: .leading)
            constantAlbumsView
                .frame(height: 124)
            TextCustom(text: "Radio", size: 28, weight: .bold, color: .black)
                .padding(.vertical, 20)
                .frame(maxWidth: .infinity, alignment: .leading)
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack(spacing: 8) {
                    ForEach(0..<20, id: \.self) { index in
                        //RadioWaveSmallView()
                    }
                }
                .clipShape(.rect(cornerRadius: 16))
            }
            .clipShape(.rect(cornerRadius: 16))
        }
        .padding(.horizontal, 16)
        .frame(maxHeight: .infinity, alignment: .top)
    }
}

#Preview {
    FavouritesView(viewModel: FavouriteViewModel(dataManager: DataManager()))
}
