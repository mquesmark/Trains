import SwiftUI
import Combine

struct StoriesView: View {

    // MARK: - Input / Dependencies

    private let stories: [Story]
    private let configuration: StoriesConfiguration
    private let onStoryShown: ((UUID) -> Void)?

    // MARK: - Environment

    @Environment(\.dismiss) private var dismiss

    // MARK: - State

    @State private var progress: CGFloat
    @State private var shownIDs: Set<UUID> = []

    // MARK: - Timer / Combine

    @State private var timer: Timer.TimerPublisher
    @State private var cancellable: Cancellable?

    // MARK: - Computed properties

    private var currentStoryIndex: Int {
        let count = max(stories.count, 1)
        return min(Int(progress * CGFloat(count)), count - 1)
    }

    private var currentStory: Story {
        stories[currentStoryIndex]
    }

    // MARK: - Init

    init(
        stories: [Story] = Mocks.stories,
        startIndex: Int = 0,
        onStoryShown: ((UUID) -> Void)? = nil
    ) {
        self.stories = stories
        self.onStoryShown = onStoryShown
        configuration = StoriesConfiguration(storiesCount: stories.count)
        timer = StoriesView.createTimer(configuration: configuration)

        let count = stories.count
        if count == 0 {
            progress = 0
            return
        }

        let index = max(0, min(startIndex, count - 1))
        progress = CGFloat(index) / CGFloat(count)
    }

    // MARK: - Body

    var body: some View {
        ZStack(alignment: .top) {
            StoryView(story: currentStory)
                .padding(.zero)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            gestureLayer
            VStack(alignment: .trailing, spacing: 16) {
                ProgressBar(numberOfSections: stories.count, progress: progress)
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
        .onAppear {
            timer = Self.createTimer(configuration: configuration)
            cancellable = timer.connect()
        }
        .onDisappear {
            cancellable?.cancel()
        }
        .onReceive(timer) { _ in
            timerTick()
        }
        .onAppear {
            reportShown(id: currentStory.id)
        }
        .onChange(of: currentStory.id) { _, newId in
            reportShown(id: newId)
        }
    }
    
    // MARK: - Story shown reporting

    private func reportShown(id: UUID) {
        guard !shownIDs.contains(id) else { return }
        shownIDs.insert(id)
        onStoryShown?(id)
    }

    // MARK: - Gestures

    private var gestureLayer: some View {
        GeometryReader { geo in
            HStack(spacing: .zero) {
                Color.clear
                    .contentShape(Rectangle())
                    .onTapGesture {
                        prevStory()
                    }
                Color.clear
                    .contentShape(Rectangle())
                    .onTapGesture {
                        nextStory()
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
                        nextStory()
                    } else {
                        prevStory()
                    }
                    resetTimer()
                    return
                }

                if dy > verticalThreshold {
                    dismiss()
                }
            }
    }

    // MARK: - Timer

    private func timerTick() {
        var nextProgress = progress + configuration.progressPerTick
        if nextProgress >= 1 {
            nextProgress = 0
        }
        withAnimation {
            progress = nextProgress
        }
    }

    // MARK: - Story navigation

    private func nextStory() {
        let storiesCount = stories.count
        let currentStoryIndex = Int(progress * CGFloat(storiesCount))
        let nextStoryIndex = currentStoryIndex + 1 < storiesCount ? currentStoryIndex + 1 : 0
        withAnimation {
            progress = CGFloat(nextStoryIndex) / CGFloat(storiesCount)
        }
    }

    private func prevStory() {
        let storiesCount = stories.count
        let currentIndex = Int(progress * CGFloat(storiesCount))
        let prevIndex = currentIndex - 1 >= 0 ? currentIndex - 1 : storiesCount - 1

        withAnimation {
            progress = CGFloat(prevIndex) / CGFloat(storiesCount)
        }
    }
    
    private func resetTimer() {
        cancellable?.cancel()
        timer = Self.createTimer(configuration: configuration)
        cancellable = timer.connect()
    }

    private static func createTimer(configuration: StoriesConfiguration) -> Timer.TimerPublisher {
        Timer.publish(every: configuration.timerTickInternal, on: .main, in: .common)
    }
}

#Preview {
    StoriesView()
}
