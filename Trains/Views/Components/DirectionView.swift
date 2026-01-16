import SwiftUI

/// Этот компонент намеренно реализован без ViewModel.
/// "DirectionView" — внутренняя UI-вью "MainScreen": она получает данные через "@Binding" и сообщает о действиях через колбэки,
/// а состояние и логика сценария находятся в "MainScreenViewModel".

struct DirectionView: View {
    @Binding var fromCity: City?
    @Binding var fromStation: Station?
    @Binding var toCity: City?
    @Binding var toStation: Station?

    var fromText: String? {
        guard let city = fromCity, let station = fromStation else {
            return nil
        }
        return "\(city.title) (\(station.title))"
    }
    var toText: String? {
        guard let city = toCity, let station = toStation else {
            return nil
        }
        return "\(city.title) (\(station.title))"
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
