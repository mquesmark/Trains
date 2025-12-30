import SwiftUI
import Combine

struct StoriesView: View {
    struct Configuration {
        let timerTickInternal: TimeInterval
        let progressPerTick: CGFloat

        init(
            storiesCount: Int,
            secondsPerStory: TimeInterval = 5,
            timerTickInternal: TimeInterval = 0.05
        ) {
            self.timerTickInternal = timerTickInternal
            self.progressPerTick = 1.0 / CGFloat(storiesCount) / secondsPerStory * timerTickInternal
        }
    }

    private let stories: [Story]
    private let configuration: Configuration
    private var currentStory: Story { stories[currentStoryIndex] }
    private var currentStoryIndex: Int {
        let count = max(stories.count, 1)
        return min(Int(progress * CGFloat(count)), count - 1)
    }
    @State private var progress: CGFloat
    @Environment(\.dismiss) private var dismiss

    private let onStoryShown: ((UUID) -> Void)?
    @State private var shownIDs: Set<UUID> = []

    @State private var timer: Timer.TimerPublisher
    @State private var cancellable: Cancellable?
    init(
        stories: [Story] = Mocks.stories,
        startIndex: Int = 0,
        onStoryShown: ((UUID) -> Void)? = nil
    ) {
        self.stories = stories
        self.onStoryShown = onStoryShown
        configuration = Configuration(storiesCount: stories.count)
        timer = StoriesView.createTimer(configuration: configuration)

        let count = stories.count
        if count == 0 {
            progress = 0
            return
        }

        let index = max(0, min(startIndex, count - 1))
        progress = CGFloat(index) / CGFloat(count)
    }

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
        .onChange(of: currentStory.id) { newId in
            reportShown(id: newId)
        }
    }
    
    private func reportShown(id: UUID) {
        guard !shownIDs.contains(id) else { return }
        shownIDs.insert(id)
        onStoryShown?(id)
    }

    private var gestureLayer: some View {
        GeometryReader { geo in
            HStack(spacing: 0) {
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

    private func timerTick() {
        var nextProgress = progress + configuration.progressPerTick
        if nextProgress >= 1 {
            nextProgress = 0
        }
        withAnimation {
            progress = nextProgress
        }
    }

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

    private static func createTimer(configuration: Configuration) -> Timer.TimerPublisher {
        Timer.publish(every: configuration.timerTickInternal, on: .main, in: .common)
    }
}

#Preview {
    StoriesView()
}
