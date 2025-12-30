import SwiftUI

struct StoryPreviewView: View {
    
    var model: Story
    
    var body: some View {
        
        image
            .overlay(alignment: .bottomLeading) {
                titleText
            }
            .overlay {
                if !model.isWatched {
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(.blueUniversal, lineWidth: 4)
                }
            }
    }
    
    private var titleText: some View {
        Text(model.previewTitle)
            .font(.system(size: 12, weight: .regular))
            .foregroundStyle(.white)
            .opacity(model.isWatched ? 0.5 : 1)
            .lineLimit(3)
            .padding(.horizontal, 8)
            .padding(.bottom, 12)
    }
    
    private var image: some View {
        model.previewImage
            .resizable()
            .scaledToFill()
            .frame(width: 92, height: 140)
            .clipped()
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .opacity(model.isWatched ? 0.5 : 1)
    }
}

#Preview {
    StoryPreviewView(model: Mocks.stories[0])
    StoryPreviewView(model: Mocks.stories[3])

}
