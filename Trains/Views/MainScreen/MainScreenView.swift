import SwiftUI

enum Route: Hashable {
    case cities(PickTarget)
    case stations(PickTarget, city: City)
    case results(routeString: String)
    case carrierInfo
    case story(startIndex: Int)
}

struct MainScreenView: View {
    
    @State private var path: [Route] = []
    @StateObject private var viewModel = MainScreenViewModel()
    private let stationsRepository = APIEnvironment.shared.stationsRepository

    var body: some View {
        NavigationStack(path: $path) {
            content
                .background(.backgroundYP)
                .navigationDestination(for: Route.self) { route in
                    destination(for: route)
                }
        }
        .task {
            try? await stationsRepository.loadInfoIfNeeded()
        }
    }

    // MARK: - Content

    private var content: some View {
        VStack {
            storiesStrip
                .frame(height: 188) // Так по макету

            directionView

            if viewModel.canSearch {
                searchButton
            }

            Spacer()
        }
    }

    private var storiesStrip: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 12) {
                ForEach(viewModel.storiesPreview.indices, id: \.self) { index in
                    let storyModel = viewModel.storiesPreview[index]
                    StoryPreviewView(model: storyModel)
                        .onTapGesture {
                            path.append(.story(startIndex: index))
                        }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 24)
        }
    }

    // MARK: - Navigation

    @ViewBuilder
    private func destination(for route: Route) -> some View {
        switch route {
        case .cities(let target):
            CitySelectionView(target: target, path: $path, stationsRepository: stationsRepository)
                .toolbar(.hidden, for: .tabBar)
                .navigationBarBackButtonHidden(true)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        backButton
                    }
                }

        case .stations(let target, let city):
            StationSelectionView(
                target: target,
                city: city,
                path: $path,
                fromCity: $viewModel.fromCity,
                fromStation: $viewModel.fromStation,
                toCity: $viewModel.toCity,
                toStation: $viewModel.toStation,
                stationsRepository: stationsRepository
            )
            .toolbar(.hidden, for: .tabBar)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    backButton
                }
            }

        case .results(let routeString):
            CarriersResultsView(routeString: routeString, path: $path)
                .toolbar(.hidden, for: .tabBar)
                .navigationBarBackButtonHidden()
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        backButton
                    }
                }

        case .carrierInfo:
            CarrierInfoView(carrierName: "")
                .navigationBarBackButtonHidden()
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        backButton
                    }
                }

        case .story(let startIndex):
            StoriesView(
                stories: viewModel.storiesPreview,
                startIndex: startIndex,
                onStoryShown: { shownId in
                    viewModel.markStoryWatched(id: shownId)
                }
            )
            .toolbar(.hidden, for: .tabBar)
            .navigationBarBackButtonHidden(true)
        }
    }

    
    private var directionView: some View {
        DirectionView(
            fromCity: $viewModel.fromCity,
            fromStation: $viewModel.fromStation,
            toCity: $viewModel.toCity,
            toStation: $viewModel.toStation,
            onFromTap: { path.append(.cities(.from)) },
            onToTap: { path.append(.cities(.to)) },
            onSwap: { viewModel.swapDirections() }
        )
        .padding(.init(top: 20, leading: 16, bottom: 16, trailing: 16))
    }

    private var searchButton: some View {
        Button {
            searchTapped()
        } label: {
            Text("Найти")
                .frame(width: 150, height: 60)
                .font(.system(size: 17, weight: .bold))
                .foregroundStyle(.white)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.blueUniversal)
                )
                .contentShape(RoundedRectangle(cornerRadius: 16))
        }
        .buttonStyle(.plain)
    }

    private var backButton: some View {
        Button {
            if !path.isEmpty {
                path.removeLast()
            }
        } label: {
            Image(systemName: "chevron.left")
                .font(.system(size: 18, weight: .semibold))
                .frame(width: 44, height: 44)
                .contentShape(Circle())
        }
        .buttonStyle(.plain)
        .foregroundStyle(Color(.label))
    }

    private func searchTapped() {
        guard let routeString = viewModel.routeString else { return }
        path.append(.results(routeString: routeString))
    }
}

#Preview {
    MainScreenView()
}
