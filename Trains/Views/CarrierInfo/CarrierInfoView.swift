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
            AsyncImage(url: URL(string: viewModel.carrierInfo.logoUrlString)) { phase in
                switch phase {
                case .empty:
                    ZStack {
                        Color.black.opacity(0.05)
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
            .clipShape(RoundedRectangle(cornerRadius: 24))
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
                        .foregroundStyle(Color.blueUniversal)
                }
                .frame(height: 60)

                VStack(alignment: .leading, spacing: .zero) {
                    Text("Телефон")
                        .font(.system(size: 17, weight: .regular))

                    Text(displayOrPlaceholder(viewModel.carrierInfo.phone))
                        .font(.system(size: 12, weight: .regular))
                        .foregroundStyle(Color.blueUniversal)
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
