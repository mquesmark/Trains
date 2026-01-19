import SwiftUI

/// Этот компонент намеренно реализован без ViewModel.
/// "CarrierCardView" — презентационный UI-элемент: он только отображает переданную модель и не содержит состояния/логики сценария

struct CarrierCardView: View {

    let carrier: CarrierCardModel
    @State private var isBusPulsing = false

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
        AsyncImage(url: URL(string: carrier.carrierInfo.logoUrlString)) { phase in
            switch phase {
            case .empty:
                pulsingBusPlaceholder
                    .onAppear {
                        if !isBusPulsing { isBusPulsing = true }
                    }
            case .success(let image):
                image
                    .resizable()
                    .scaledToFill()
            case .failure:
                busPlaceholder
            @unknown default:
                busPlaceholder
            }
        }
            .frame(width: 38, height: 38)
            .background(Color.blackUniversal.opacity(0.05))
            .clipped()
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    }

    private var busPlaceholder: some View {
        Image(systemName: "bus.doubledecker")
            .resizable()
            .scaledToFit()
            .padding(10)
            .foregroundStyle(Color(.blueUniversal))
    }

    private var pulsingBusPlaceholder: some View {
        Image(systemName: "bus")
            .resizable()
            .scaledToFit()
            .padding(10)
            .foregroundStyle(Color(.blackUniversal).opacity(0.95))
            .shimmer(duration: 2, bandSize: 0.5, highlightOpacity: 0.75, blur: 7)

    }
    
    private var titleView: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(carrier.carrierInfo.name)
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
