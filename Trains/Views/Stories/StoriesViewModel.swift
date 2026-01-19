import SwiftUI
import Combine

@MainActor
final class StoriesViewModel: ObservableObject {

    // MARK: - Dependencies

    private let stories: [Story]
    private let configuration: StoriesConfiguration
    private let onStoryShown: (@Sendable (UUID) -> Void)?

    // MARK: - State

    @Published var progress: CGFloat

    private var shownIDs: Set<UUID> = []
    private var resetCounter: UInt64 = 0

    // MARK: - Computed

    var currentStoryIndex: Int {
        let count = stories.count
        guard count > 0 else { return 0 }
        return min(Int(progress * CGFloat(count)), count - 1)
    }

    var currentStory: Story? {
        guard !stories.isEmpty else { return nil }
        return stories[currentStoryIndex]
    }

    // MARK: - Init

    init(
        stories: [Story],
        configuration: StoriesConfiguration,
        startIndex: Int,
        onStoryShown: (@Sendable (UUID) -> Void)?
    ) {
        self.stories = stories
        self.configuration = configuration
        self.onStoryShown = onStoryShown

        let count = stories.count
        if count == 0 {
            progress = 0
        } else {
            let index = max(0, min(startIndex, count - 1))
            progress = CGFloat(index) / CGFloat(count)
        }

        reportShownIfNeeded()
    }

    // MARK: - Public API

    func runTimer() async {
        // Привязано к жизненному циклу View через `.task {}`: при уничтожении View задача отменится.
        while !Task.isCancelled {
            let localReset = resetCounter
            do {
                try await Task.sleep(nanoseconds: UInt64(configuration.timerTickInternal * 1_000_000_000))
            } catch {
                break
            }
            if Task.isCancelled { break }

            // Если во время сна был reset — начинаем отсчет заново (без тика).
            if localReset != resetCounter {
                continue
            }

            timerTick()
        }
    }

    func nextStory() {
        guard !stories.isEmpty else { return }
        requestTimerReset()

        let count = stories.count
        let currentIndex = Int(progress * CGFloat(count))
        let nextIndex = currentIndex + 1 < count ? currentIndex + 1 : 0

        withAnimation {
            progress = CGFloat(nextIndex) / CGFloat(count)
        }
        reportShownIfNeeded()
    }

    func prevStory() {
        guard !stories.isEmpty else { return }
        requestTimerReset()

        let count = stories.count
        let currentIndex = Int(progress * CGFloat(count))
        let prevIndex = currentIndex - 1 >= 0 ? currentIndex - 1 : count - 1

        withAnimation {
            progress = CGFloat(prevIndex) / CGFloat(count)
        }
        reportShownIfNeeded()
    }

    // MARK: - Private

    private func timerTick() {
        guard !stories.isEmpty else { return }

        var next = progress + configuration.progressPerTick
        if next >= 1 {
            next = 0
        }
        withAnimation {
            progress = next
        }
        reportShownIfNeeded()
    }

    private func reportShownIfNeeded() {
        guard let id = currentStory?.id else { return }
        guard !shownIDs.contains(id) else { return }
        shownIDs.insert(id)
        onStoryShown?(id)
    }

    private func requestTimerReset() {
        resetCounter &+= 1
    }
}
