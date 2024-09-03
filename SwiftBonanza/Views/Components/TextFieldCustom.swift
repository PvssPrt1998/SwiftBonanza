import SwiftUI

struct TextFieldCustom: View {
    
    @Binding var text: String
    
    let placeholder: String
    var trailingPadding: CGFloat = 0
    
    var body: some View {
        TextField("", text: $text)
            .fontCustom(size: 17, weight: .regular, color: Color.white)
            .autocorrectionDisabled(true)
            .background(
                placeholderView()
            )
    }
    
    @ViewBuilder func placeholderView() -> some View {
        Text(text != "" ? "" : placeholder)
            .fontCustom(size: 17, weight: .regular, color: Color.white.opacity(0.62))
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct TextFieldCustom_Preview: PreviewProvider {
    
    @State static var text = ""
    
    static var previews: some View {
        TextFieldCustom(text: $text, placeholder: "Title")
            .padding()
            .background(Color.black)
            .frame(height: 200)
    }
}
