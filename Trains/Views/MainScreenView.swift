import SwiftUI

enum Route: Hashable {
    case cities(PickTarget)
    case stations(PickTarget, city: String)
    case results(routeString: String)
    case carrierInfo
    case story(startIndex: Int)
}

struct MainScreenView: View {

    @State private var path: [Route] = []
    @State private var fromCity: String? = nil
    @State private var fromStation: String? = nil
    @State private var toCity: String? = nil
    @State private var toStation: String? = nil
    @State private var storiesPreview: [Story] = Mocks.stories

    private var canSearch: Bool {
        fromCity != nil && fromStation != nil && toCity != nil && toStation != nil
    }
    private var routeString: String {
        "\(fromCity!) (\(fromStation!)) → \(toCity!) (\(toStation!))"
    }

    var body: some View {
        NavigationStack(path: $path) {
            content
                .background(.backgroundYP)
                .navigationDestination(for: Route.self) { route in
                    destination(for: route)
                }
        }
    }

    // MARK: - Content

    private var content: some View {
        VStack {
            storiesStrip
                .frame(height: 188) // Так по макету

            directionView

            if canSearch {
                searchButton
            }

            Spacer()
        }
    }

    private var storiesStrip: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 12) {
                ForEach(storiesPreview.indices, id: \.self) { index in
                    let storyModel = storiesPreview[index]
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
            CitySelectionView(target: target, path: $path)
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
                fromCity: $fromCity,
                fromStation: $fromStation,
                toCity: $toCity,
                toStation: $toStation
            )
            .toolbar(.hidden, for: .tabBar)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    backButton
                }
            }

        case .results(let routeString):
            CarriersResultsView(routeString: routeString, path: $path)
                .toolbar(.hidden, for: .tabBar)
                .navigationBarBackButtonHidden(true)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        backButton
                    }
                }

        case .carrierInfo:
            CarrierInfoView()

        case .story(let startIndex):
            StoriesView(
                stories: storiesPreview,
                startIndex: startIndex,
                onStoryShown: { shownId in
                    if let index = storiesPreview.firstIndex(where: { $0.id == shownId }) {
                        storiesPreview[index].isWatched = true
                    }
                }
            )
            .toolbar(.hidden, for: .tabBar)
            .navigationBarBackButtonHidden(true)
        }
    }

    
    private var directionView: some View {
        DirectionView(
            fromCity: $fromCity,
            fromStation: $fromStation,
            toCity: $toCity,
            toStation: $toStation,
            onFromTap: { path.append(.cities(.from)) },
            onToTap: { path.append(.cities(.to)) }
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
            path.removeLast()
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
        path.append(.results(routeString: routeString))
    }
}

#Preview {
    MainScreenView()
}
