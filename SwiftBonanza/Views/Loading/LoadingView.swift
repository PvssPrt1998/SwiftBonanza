import SwiftUI

struct LoadingView: View {
    
    @ObservedObject var viewModel: LoadingViewModel
    
    var body: some View {
        ZStack {
            Image(ImageTitles.LoadingScreenBackground.rawValue)
                .resizable()
            ProgressViewCustom(value: $viewModel.value)
        }
        .ignoresSafeArea()
        .onAppear {
            viewModel.stroke()
            viewModel.loadData()
        }
    }
}

#Preview {
    LoadingView(viewModel: LoadingViewModel(dataManager: DataManager()))
}
