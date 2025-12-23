import SwiftUI

struct StationSelectionView: View {

    private let stations: [String] = [
        "Киевский вокзал",
        "Курский вокзал",
        "Ярославский вокзал",
        "Белорусский вокзал",
        "Савеловский вокзал",
        "Ленинградский вокзал"
    ]

    @State private var searchText = ""

    private var filteredStations: [String] {
        if searchText.isEmpty {
            return stations
        } else {
            return stations.filter {
                $0.localizedCaseInsensitiveContains(searchText)
            }
        }
    }

    var body: some View {
        Group {
            if !searchText.isEmpty && filteredStations.isEmpty {
                Text("Станция не найдена")
                    .font(.system(size: 17, weight: .semibold))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                List(filteredStations, id: \.self) { station in
                    HStack {
                        Text(station)
                            .font(.system(size: 17, weight: .regular))
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(Color(.label))
                    }
                    .frame(height: 60)
                    .listRowBackground(Color.backgroundYP)
                    .listRowInsets(
                        EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
                    )
                    .listRowSeparator(.hidden)
                    .onTapGesture {
                        didSelectStation(station)
                    }
                }
                .listStyle(.plain)
            }
        }
        .navigationTitle("Выбор станции")
        .navigationBarTitleDisplayMode(.inline)
        .background(.backgroundYP)
        .searchable(
            text: $searchText,
            placement: .navigationBarDrawer(displayMode: .always),
            prompt: "Введите запрос"
        )
    }

    private func didSelectStation(_ station: String) {
        print(station)
    }
}

#Preview {
    NavigationStack {
        StationSelectionView()
    }
}
#Preview {
    NavigationStack {
        StationSelectionView()
            .preferredColorScheme(.dark)
    }
}
