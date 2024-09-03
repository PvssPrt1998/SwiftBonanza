import SwiftUI
import StoreKit

struct SettingsView: View {
    
    @State var showPrivacy = false
    
    var settings: some View {
        VStack(spacing: 0) {
            HStack(spacing: 2) {
                TextCustom(text: "Swiit bronanza", size: 17, weight: .semibold, color: .primaryPink)
                Image(ImageTitles.BronanzaLogo.rawValue)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 29, height: 32)
            }
            .padding(.top, 3)
            TextCustom(text: "Settings", size: 36, weight: .bold, color: .black)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(EdgeInsets(top: 57, leading: 16, bottom: 8, trailing: 16))
            
            VStack(spacing: 15) {
                Button {
                    actionSheet()
                } label: {
                    VStack(spacing: 4) {
                        Image(systemName: "square.and.arrow.up.fill")
                            .resizable()
                            .scaledToFit()
                            .foregroundColorCustom(.primaryPink)
                            .frame(width: 24, height: 24)
                        TextCustom(text: "Share app", size: 20, weight: .semibold, color: .primaryPink)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.white)
                    .clipShape(.rect(cornerRadius: 16))
                    .frame(height: 100)
                    .shadow(color: .c455219615, radius: 5.2, y: 2)
                }
                Button {
                    SKStoreReviewController.requestReviewInCurrentScene()
                } label: {
                    VStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .resizable()
                            .scaledToFit()
                            .foregroundColorCustom(.primaryPink)
                            .frame(width: 24, height: 24)
                        TextCustom(text: "Rate Us", size: 20, weight: .semibold, color: .primaryPink)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.white)
                    .clipShape(.rect(cornerRadius: 16))
                    .frame(height: 100)
                    .shadow(color: .c455219615, radius: 5.2, y: 2)
                }
                Button {
                    showPrivacy = true
                } label: {
                    VStack(spacing: 4) {
                        Image(systemName: "doc.text.fill")
                            .resizable()
                            .scaledToFit()
                            .foregroundColorCustom(.primaryPink)
                            .frame(width: 24, height: 24)
                        TextCustom(text: "Usage Policy", size: 20, weight: .semibold, color: .primaryPink)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.white)
                    .clipShape(.rect(cornerRadius: 16))
                    .frame(height: 100)
                    .shadow(color: .c455219615, radius: 5.2, y: 2)
                }
            }
            .padding(EdgeInsets(top: 60, leading: 16, bottom: 0, trailing: 16))
        }
        .frame(maxHeight: .infinity, alignment: .top)
    }
    
    var body: some View {
        ZStack {
            settings
            if showPrivacy {
                SettingsWebView(action: {
                    showPrivacy = false
                }, url: "https://www.google.com/")
            }
        }
    }
    
    func actionSheet() {
        guard let urlShare = URL(string: "https://apps.apple.com/app/pitcrew-kart-tracker/id6557075909") else { return }
        let activityVC = UIActivityViewController(activityItems: [urlShare], applicationActivities: nil)
        UIApplication.shared.windows.first?.rootViewController?.present(activityVC, animated: true, completion: nil)
    }
}

#Preview {
    SettingsView()
}

extension SKStoreReviewController {
    public static func requestReviewInCurrentScene() {
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            DispatchQueue.main.async {
                requestReview(in: scene)
            }
        }
    }
}
