import SwiftUI

struct SearchTextField: View {
    
    @Binding var text: String
    
    let placeholder: String
    var trailingPadding: CGFloat = 0
    
    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass")
                .resizable()
                .scaledToFit()
                .foregroundColorCustom(.specialSecondary)
                .frame(width: 25, height: 22)
                
            TextField("", text: $text)
                .fontCustom(size: 17, weight: .regular, color: Color.black)
                .autocorrectionDisabled(true)
                .background(
                    placeholderView()
                )
        }
        .padding(EdgeInsets(top: 7, leading: 8, bottom: 7, trailing: 8))
        .background(Color.specialTertiary)
        .clipShape(.rect(cornerRadius: 10))
    }
    
    @ViewBuilder func placeholderView() -> some View {
        HStack {
            Text(text != "" ? "" : placeholder)
                .fontCustom(size: 17, weight: .regular, color: Color.specialSecondary)
            Spacer()
            Button {
                text = ""
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .fontCustom(size: 17, weight: .regular, color: .specialSecondary)
            }
            .opacity(text != "" ? 1 : 0)
        }
    }
}

struct SearchTextField_Preview: PreviewProvider {
    
    @State static var text = ""
    
    static var previews: some View {
        SearchTextField(text: $text, placeholder: "Search")
            .padding()
    }
}
