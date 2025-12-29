import SwiftUI

struct CitySelectionView: View {
    let target: PickTarget
    @Binding var path: [Route]
    
    let cities: [String] = Mocks.citiesStrings
    
    @State private var searchText = ""
    var filteredCities: [String] {
        if searchText.isEmpty {
            return cities
        } else {
            return cities.filter {
                $0.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        Group {
            if !searchText.isEmpty && filteredCities.isEmpty {
                Text("Город не найден")
                    .font(.system(size: 24, weight: .bold))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                List(filteredCities, id: \.self) { city in
                    HStack {
                        Text(city)
                            .font(.system(size: 17, weight: .regular))
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(Color(.label))
                    }
                    .frame(height: 60)
                    .contentShape(Rectangle())
                    .listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.backgroundYP)
                    .onTapGesture {
                        didSelectCity(city)
                    }
                }
                .listStyle(.plain)
            }
        }
        .navigationTitle("Выбор города")
        .navigationBarTitleDisplayMode(.inline)
        .background(.backgroundYP)
        .searchable(
            text: $searchText,
            placement: .navigationBarDrawer(displayMode: .always),
            prompt: "Введите запрос"
        )
    }
    
    private func didSelectCity(_ city: String) {
        path.append(.stations(target, city: city))
    }
}

#Preview {
    NavigationStack {
        CitySelectionView(target: .from, path: .constant([]))
    }
}
