import SwiftUI

struct Story: Identifiable {
    let id: UUID = UUID()
    var isWatched: Bool

    let previewImage: Image
    let previewTitle: String
    
    let fullImage: Image
    let title: String
    let fullText: String
}
