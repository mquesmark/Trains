import SwiftUI

struct DirectionView: View {
    @Binding var fromCity: String?
    @Binding var fromStation: String?
    @Binding var toCity: String?
    @Binding var toStation: String?

    var fromText: String? {
        guard let city = fromCity, let station = fromStation else {
            return nil
        }
        return "\(city) (\(station))"
    }
    var toText: String? {
        guard let city = toCity, let station = toStation else {
            return nil
        }
        return "\(city) (\(station))"
    }

    let fromPlaceholder = "Откуда"
    let toPlaceholder = "Куда"
    let onFromTap: () -> Void
    let onToTap: () -> Void
    let onSwap: () -> Void

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.blueUniversal)
            HStack {
                VStack(spacing: 8) {
                    Text(fromText ?? fromPlaceholder)
                        .foregroundStyle(
                            fromText == nil ? .grayUniversal : .black
                        )
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(16)
                        .contentShape(Rectangle())
                        .onTapGesture { onFromTap() }

                    Text(toText ?? toPlaceholder)
                        .foregroundStyle(
                            toText == nil ? .grayUniversal : .black
                        )
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(16)
                        .contentShape(Rectangle())
                        .onTapGesture { onToTap() }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.white)
                .clipShape(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                )
                .padding(16)
                Button {
                    onSwap()
                } label: {
                    Image("change")
                }
                .padding(.trailing)
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 120)
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State private var fromCity: String? = "Москва"
        @State private var fromStation: String? = "Ленинградский"
        @State private var toCity: String? = "Санкт-Петербург"
        @State private var toStation: String? = "Московский"

        var body: some View {
            DirectionView(
                fromCity: $fromCity,
                fromStation: $fromStation,
                toCity: $toCity,
                toStation: $toStation,
                onFromTap: {},
                onToTap: {},
                onSwap: {}
            )
            .padding()
            .background(Color(.systemGroupedBackground))
        }
    }

    return PreviewWrapper()
}
