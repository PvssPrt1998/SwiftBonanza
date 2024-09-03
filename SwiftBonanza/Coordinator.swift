import SwiftUI
import Combine

final class AppCoordinator: ObservableObject {
    
    enum Pages {
        case loadingReviewer
        case onboardingReviewer
        case main
    }
    
    @Published var page: Pages = .loadingReviewer
    
    let viewModelFactory: ViewModelFactory
    
    private var dictionaryAnyCancellable = Dictionary<Pages, AnyCancellable>()
    
    init(viewModelFactory: ViewModelFactory) {
        self.viewModelFactory = viewModelFactory
    }
    
    @ViewBuilder func build() -> some View {
        switch page {
        case .loadingReviewer:
            loadingView()
        case .onboardingReviewer:
            onboardingReviewerView()
        case .main:
            MainView()
        }
    }
    
    private func loadingView() -> some View {
        let viewModel = viewModelFactory.makeLoadingViewModel()
        bind(viewModel)
        let view = LoadingView(viewModel: viewModel)
        return view
    }
    
    private func bind(_ viewModel: LoadingViewModel) {
        dictionaryAnyCancellable[.loadingReviewer] = viewModel.toNextScreen
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                self?.page = .onboardingReviewer
//                if value {
//                    self?.page = .web
//                } else {
//                    self?.page = .onboardingReviewer
//                }
            }
    }
    
    private func onboardingReviewerView() -> some View {
        let view = OnboardingViewReviewer()
        bind(view)
        return view
    }
    
    private func bind(_ view: OnboardingViewReviewer) {
        dictionaryAnyCancellable[.onboardingReviewer] = view.toNextScreen
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.page = .main
            }
    }
}
