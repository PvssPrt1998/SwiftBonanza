import SwiftUI
import Combine

struct OnboardingViewReviewer: View {
    
    let toNextScreen = PassthroughSubject<Bool, Never>()
    
    private var backgroundsTitles = [
        ImageTitles.ReviewerOnboarding1.rawValue,
        ImageTitles.ReviewerOnboarding2.rawValue,
        ImageTitles.ReviewerOnboarding3.rawValue
    ]
    
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    @State private var selection = 0
    
    init() {
        UIScrollView.appearance().bounces = false
    }
    
    var body: some View {
        ZStack {
            ScrollView(.init()) {
                TabView(selection: $selection) {
                    ForEach(backgroundsTitles.indices, id: \.self) { index in
                        Image(backgroundsTitles[index])
                            .resizable()
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .overlay(
                    ZStack {
                        indicatorAndTextView()
                        ZStack {
                            VStack(spacing: 0) {
                                LinearGradient(colors: [.white.opacity(0), .white], startPoint: .top, endPoint: .bottom)
                                    .frame(height: 60)
                                    
                                Rectangle()
                                    .fill(.white)
                                    .frame(height: 114)
                                    .overlay(
                                        Button {
                                            nextButtonPressed()
                                        } label: {
                                            TextCustom(text: "Next", size: 17, weight: .semibold, color: .white)
                                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                                .background(Color.primaryPink)
                                                .clipShape(.rect(cornerRadius: 16))
                                        }
                                        .frame(height: 54)
                                        .padding(.horizontal, 24)
                                        
                                        , alignment: .top
                                    )
                            }
                            .frame(maxHeight: .infinity, alignment: .bottom)
                            
                        }
                    }
                )
            }
            .ignoresSafeArea()
        }
    }
    
    private func nextButtonPressed() {
        if selection < 2 {
            withAnimation {
                selection += 1
            }
        } else {
            toNextScreen.send(true)
        }
    }
    
    private func indicatorAndTextView() -> some View {
        VStack(spacing: 20) {
            HStack(spacing: 8) {
                RoundedRectangle(cornerRadius: 10)
                    .fill(selection == 0 ? Color.c1290102 : Color.c22795152)
                    .frame(width: 40, height: 5)
                RoundedRectangle(cornerRadius: 10)
                    .fill(selection == 1 ? Color.c1290102 : Color.c22795152)
                    .frame(width: 40, height: 5)
                RoundedRectangle(cornerRadius: 10)
                    .fill(selection == 2 ? Color.c1290102 : Color.c22795152)
                    .frame(width: 40, height: 5)
            }
            
            TextCustom(text: textForSelection(), size: 32, weight: .bold, color: .white)
                .multilineTextAlignment(.center)
        }
        .padding(.top, safeAreaInsets.top + 20)
        .frame(maxHeight: .infinity, alignment: .top)
    }
    
    private func textForSelection() -> String {
        switch selection {
        case 0: return "Tune in to any available\nwave"
        case 1: return "Create albums with your favorite music"
        case 2: return "Listen and save radio waves and artists"
        default: return "Invalid onoarding index"
        }
    }
}

#Preview {
    OnboardingViewReviewer()
}
