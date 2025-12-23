import SwiftUI

struct CitySelectionView: View {
    let cities: [String] = [
        "Москва", "Санкт-Петербург", "Новосибирск", "Казань",
        "Омск", "Томск", "Челябинск", "Иркутск",
        "Ярославль", "Нижний Новгород"
    ]
    
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
        
    }
}

#Preview {
    NavigationStack() {
        CitySelectionView()
    }
}
#Preview {
    NavigationStack() {
        CitySelectionView()
            .preferredColorScheme(.dark)
    }
}
