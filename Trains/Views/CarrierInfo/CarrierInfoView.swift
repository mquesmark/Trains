import SwiftUI

struct CarrierInfoView: View {
    let carrierInfo: CarrierInfo
    @StateObject private var viewModel: CarrierInfoViewModel
    @Environment(\.dismiss) private var dismiss

    init(carrierInfo: CarrierInfo) {
        self.carrierInfo = carrierInfo
        _viewModel = StateObject(wrappedValue: CarrierInfoViewModel(carrierInfo: carrierInfo))
    }

    private func displayOrPlaceholder(_ value: String) -> String {
        let trimmed = value.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? "Нет информации" : value
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            AsyncImage(url: URL(string: viewModel.carrierInfo.imageUrlString)) { phase in
                switch phase {
                case .empty:
                    ZStack {
                        Color.black.opacity(0.05)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                        ProgressView()
                    }
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                default:
                    EmptyView()
                }
            }
            .frame(height: 100)
            .frame(maxWidth: .infinity)
            
            Text(viewModel.carrierInfo.name)
                .font(.system(size: 24, weight: .bold))
            
            VStack(alignment: .leading, spacing: .zero) {

                VStack(alignment: .leading, spacing: .zero) {
                    Text("E-mail")
                        .font(.system(size: 17, weight: .regular))

                    Text(displayOrPlaceholder(viewModel.carrierInfo.email))
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(.blueUniversal)
                }
                .frame(height: 60)

                VStack(alignment: .leading, spacing: .zero) {
                    Text("Телефон")
                        .font(.system(size: 17, weight: .regular))

                    Text(displayOrPlaceholder(viewModel.carrierInfo.phone))
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(.blueUniversal)
                }
                .frame(height: 60)

            }
            
            Spacer()
        }
        .contentShape(Rectangle())
        .padding(16)
        .highPriorityGesture(
            DragGesture(minimumDistance: 20, coordinateSpace: .local)
                .onEnded { value in
                    if value.translation.width > 80 && abs(value.translation.height) < 40 {
                        dismiss()
                    }
                }
        )
    }
    
    
}

#Preview("Success") {
    CarrierInfoView(
        carrierInfo: CarrierInfo(
            code: "",
            imageUrlString: "https://upload.wikimedia.org/wikipedia/commons/b/b8/RZD.svg",
            name: "РЖД",
            email: "info@rzd.ru",
            phone: "+7 800 775-00-00"
        )
    )
}

#Preview("Loading") {
    CarrierInfoView(
        carrierInfo: CarrierInfo(
            code: "",
            imageUrlString: "https://example.com/loading.png", // долго грузится
            name: "Загружается...",
            email: "",
            phone: ""
        )
    )
}

#Preview("Failure") {
    CarrierInfoView(
        carrierInfo: CarrierInfo(
            code: "",
            imageUrlString: "https://example.com/404.png", // гарантированный фейл
            name: "Перевозчик",
            email: "—",
            phone: "—"
        )
    )
}
