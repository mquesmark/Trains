import SwiftUI

struct StoriesView: View {

    // MARK: - Input / Dependencies

    private let stories: [Story]
    private let onStoryShown: (@MainActor @Sendable (UUID) -> Void)?

    // MARK: - Environment

    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: StoriesViewModel

    // MARK: - Init

    init(
        stories: [Story] = Mocks.stories,
        startIndex: Int = 0,
        onStoryShown: (@MainActor @Sendable (UUID) -> Void)? = nil
    ) {
        self.stories = stories
        self.onStoryShown = onStoryShown
        let config = StoriesConfiguration(storiesCount: stories.count)
        _viewModel = StateObject(
            wrappedValue: StoriesViewModel(
                stories: stories,
                configuration: config,
                startIndex: startIndex,
                onStoryShown: onStoryShown
            )
        )
    }

    // MARK: - Body

    var body: some View {
        ZStack(alignment: .top) {
            if let story = viewModel.currentStory {
                StoryView(story: story)
                    .padding(.zero)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                Color.clear
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            gestureLayer
            VStack(alignment: .trailing, spacing: 16) {
                ProgressBar(numberOfSections: stories.count, progress: viewModel.progress)
                    .padding(.top, 35)
                    .padding(.horizontal, 12)
                    .frame(maxHeight: 6)
                
                CloseButton(action: { dismiss() })
                    .padding(.top, 12)
                    .padding(.trailing, 12)
                
                Spacer()
            }
            .frame(maxHeight: .infinity, alignment: .top)
        }
        .task {
            await viewModel.runTimer()
        }
    }
    
    // MARK: - Gestures

    private var gestureLayer: some View {
        GeometryReader { geo in
            HStack(spacing: .zero) {
                Color.clear
                    .contentShape(Rectangle())
                    .onTapGesture {
                        viewModel.prevStory()
                    }
                Color.clear
                    .contentShape(Rectangle())
                    .onTapGesture {
                        viewModel.nextStory()
                    }
            }
        }
        .gesture(storySwipeGesture)
    }

    private var storySwipeGesture: some Gesture {
        DragGesture(minimumDistance: 20)
            .onEnded { value in
                let dx = value.translation.width
                let dy = value.translation.height

                let horizontalThreshold: CGFloat = 50
                let verticalThreshold: CGFloat = 100

                if abs(dx) > abs(dy), abs(dx) > horizontalThreshold {
                    if dx < 0 {
                        viewModel.nextStory()
                    } else {
                        viewModel.prevStory()
                    }
                    return
                }

                if dy > verticalThreshold {
                    dismiss()
                }
            }
    }
}
