import SwiftUI

struct CarrierCardView: View {
    
    let carrier: CarrierCardModel
    
    var body: some View {
        VStack(spacing: 18) {
            HStack(alignment: .top) {
                Image(.railwaysMock)
                    .frame(width: 38, height: 38)
                VStack(alignment: .leading, spacing: 2) {
                    Text(carrier.name)
                    if let warningText = carrier.warningText {
                        Text(warningText)
                            .font(.system(size: 12))
                            .foregroundStyle(Color.redUniversal)
                    }
                }
                .frame(height: 38, alignment: carrier.warningText == nil ? .center : .top)
                Spacer()
                
                Text(carrier.date)
                    .font(.system(size: 12))
            }
            HStack {
                Text(carrier.startTime)
                Rectangle()
                    .fill(Color.grayUniversal)
                    .frame(height: 1)
                Text(carrier.routeTime)
                    .font(.system(size: 12))
                Rectangle()
                    .fill(Color.grayUniversal)
                    .frame(height: 1)
                Text(carrier.endTime)
            }
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color.lightGrayYP)
        )
        .foregroundStyle(.blackUniversal)
    }
}

#Preview {
   let card = CarrierCardModel(date: "14 января", startTime: "22:30", endTime: "08:15", routeTime: "20 часов", logo: "", name: "РЖД")
    CarrierCardView(carrier: card)
    let card2 = CarrierCardModel(date: "14 января", startTime: "22:30", endTime: "08:15", routeTime: "20 часов", logo: "", name: "РЖД", warningText: "С остановками по пути")
     CarrierCardView(carrier: card2)
}
#Preview {
    let card = CarrierCardModel(date: "14 января", startTime: "22:30", endTime: "08:15", routeTime: "20 часов", logo: "", name: "РЖД")
     CarrierCardView(carrier: card)
     let card2 = CarrierCardModel(date: "14 января", startTime: "22:30", endTime: "08:15", routeTime: "20 часов", logo: "", name: "РЖД", warningText: "С остановками по пути")
      CarrierCardView(carrier: card2)
        .preferredColorScheme(.dark)
}
