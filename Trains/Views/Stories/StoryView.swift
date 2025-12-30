import SwiftUI

struct StoryView: View {
    let story: Story

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .bottomLeading) {
                story.fullImage
                    .resizable()
                    .scaledToFill()
                    .frame(width: geo.size.width, height: geo.size.height)

                VStack(alignment: .leading, spacing: 16) {
                    Text(story.title)
                        .font(.system(size: 34, weight: .bold))
                        .foregroundStyle(.white)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)

                    Text(story.fullText)
                        .font(.system(size: 20, weight: .regular))
                        .foregroundStyle(.white)
                        .lineLimit(3)
                        .multilineTextAlignment(.leading)
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 40)
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 40))
        .background(.blackUniversal)
    }
}

#Preview {
    StoryView(story: Mocks.stories[0])
}
