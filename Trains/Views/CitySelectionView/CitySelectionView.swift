import SwiftUI

struct CitySelectionView: View {
    let target: PickTarget
    @Binding var path: [Route]
        
    @StateObject private var viewModel = CitySelectionViewModel()
    
    var body: some View {
        Group {
            if viewModel.isNotFoundState {
                Text("Город не найден")
                    .font(.system(size: 24, weight: .bold))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                List(viewModel.filteredCities, id: \.self) { city in
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
            text: $viewModel.searchText,
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
