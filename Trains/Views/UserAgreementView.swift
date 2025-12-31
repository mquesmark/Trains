import SwiftUI
import WebKit

struct UserAgreementView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        WebView()
            .ignoresSafeArea()
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Пользовательское соглашение")
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    backButton
                }
            }
            .toolbar(.hidden, for: .tabBar)

    }
    
    private var backButton: some View {
        Button {
            dismiss()
        } label: {
            Image(systemName: "chevron.left")
                .font(.system(size: 18, weight: .semibold))
                .frame(width: 44, height: 44)
                .contentShape(Circle())
        }
        .buttonStyle(.plain)
        .foregroundStyle(Color(.label))
    }
}

struct WebView: UIViewRepresentable {
    
    private let url = URL(string: "https://yandex.ru/legal/practicum_offer")

    func makeUIView(context: Context) -> WKWebView {
        WKWebView()
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        guard let url else { return }
        if webView.url == nil {
            webView.load(URLRequest(url: url))
        }
    }
}

#Preview {
    UserAgreementView()
}
