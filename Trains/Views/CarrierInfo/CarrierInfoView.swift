import SwiftUI

struct CarrierInfoView: View {
    var carrierName: String
    @StateObject private var viewModel: CarrierInfoViewModel
    
    init(carrierName: String) {
        self.carrierName = carrierName
        _viewModel = StateObject(wrappedValue: CarrierInfoViewModel(carrierName: carrierName))
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Image(.rzdLarge)
                .resizable()
                .scaledToFit()
            
            Text(viewModel.carrierInfo.name)
                .font(.system(size: 24, weight: .bold))
            
            VStack(alignment: .leading, spacing: .zero) {

                VStack(alignment: .leading, spacing: .zero) {
                    Text("E-mail")
                        .font(.system(size: 17, weight: .regular))

                    Text(viewModel.carrierInfo.email)
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(.blueUniversal)
                }
                .frame(height: 60)

                VStack(alignment: .leading, spacing: .zero) {
                    Text("Телефон")
                        .font(.system(size: 17, weight: .regular))

                    Text(viewModel.carrierInfo.phone)
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(.blueUniversal)
                }
                .frame(height: 60)

            }
            
            Spacer()
        }
        .padding(16)
    }
    
    
}

#Preview {
    CarrierInfoView(carrierName: "RZD")
}
