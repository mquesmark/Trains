import SwiftUI

/// Этот компонент намеренно реализован без ViewModel.
/// "CarrierCardView" — презентационный UI-элемент: он только отображает переданную модель и не содержит состояния/логики сценария

struct CarrierCardView: View {

    let carrier: CarrierCardModel

    var body: some View {
        VStack(spacing: 18) {
            headerView
            timelineView
        }
        .padding(14)
        .background(cardBackground)
        .foregroundStyle(.blackUniversal)
    }

    // MARK: - Header

    private var headerView: some View {
        HStack(alignment: .top) {
            logoView
            titleView
            Spacer()
            dateView
        }
    }

    private var logoView: some View {
        Image(carrier.logo)
            .frame(width: 38, height: 38)
    }

    private var titleView: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(carrier.name)
            if let warningText = carrier.warningText {
                Text(warningText)
                    .font(.system(size: 12))
                    .foregroundStyle(Color.redUniversal)
            }
        }
        .frame(
            height: 38,
            alignment: carrier.warningText == nil ? .center : .top
        )
    }

    private var dateView: some View {
        Text(carrier.date)
            .font(.system(size: 12))
    }

    // MARK: - Timeline

    private var timelineView: some View {
        HStack {
            Text(carrier.startTime)
            separatorView
            Text(carrier.routeTime)
                .font(.system(size: 12))
            separatorView
            Text(carrier.endTime)
        }
    }

    private var separatorView: some View {
        Rectangle()
            .fill(Color.grayUniversal)
            .frame(height: 1)
    }

    // MARK: - Background

    private var cardBackground: some View {
        RoundedRectangle(cornerRadius: 24)
            .fill(Color.lightGrayYP)
    }
}


#Preview {
   let card = CarrierCardModel(date: "14 января", startTime: "22:30", endTime: "08:15", routeTime: "20 часов", logo: "rzd", name: "РЖД")
    CarrierCardView(carrier: card)
    let card2 = CarrierCardModel(date: "14 января", startTime: "22:30", endTime: "08:15", routeTime: "20 часов", logo: "rzd", name: "РЖД", warningText: "С остановками по пути")
     CarrierCardView(carrier: card2)
}
