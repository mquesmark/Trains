import SwiftUI

struct CarrierInfoView: View {
    
    let carrierInfo: CarrierInfo
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Image(.rzdLarge)
                .resizable()
                .scaledToFit()
            
            Text(carrierInfo.name)
                .font(.system(size: 24, weight: .bold))
            
            VStack(alignment: .leading, spacing: .zero) {

                VStack(alignment: .leading, spacing: .zero) {
                    Text("E-mail")
                        .font(.system(size: 17, weight: .regular))

                    Text(carrierInfo.email)
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(.blueUniversal)
                }
                .frame(height: 60)

                VStack(alignment: .leading, spacing: .zero) {
                    Text("Телефон")
                        .font(.system(size: 17, weight: .regular))

                    Text(carrierInfo.phone)
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
    CarrierInfoView(carrierInfo: .init(imageUrlString: "", name: "ОАО «РЖД»", email: "i.lozgkina@yandex.ru", phone: "+7 (904) 329-27-71"))
}
