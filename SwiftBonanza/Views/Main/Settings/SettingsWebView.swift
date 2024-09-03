import SwiftUI
import Combine

struct SettingsWebView: View {
    @State var isLoaderVisible = true
    @StateObject var viewModel = WebViewModel()
    let action: () -> Void

    let url: String
    
    var body: some View {
        VStack {
            Button {
                action()
            } label: {
                Text("Close")
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
            ZStack {
                WebView(viewModel: viewModel, type: .public, url: url)
                    .onReceive(self.viewModel.isLoaderVisible.receive(on: RunLoop.main)) { value in
                        self.isLoaderVisible = value
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                if isLoaderVisible {
                    ProgressView()
                }
            }
        }
        .padding([.horizontal, .top], 16)
        .background(Color.white)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

final class WebViewModel: ObservableObject {
    var isLoaderVisible = PassthroughSubject<Bool, Never>();
}

