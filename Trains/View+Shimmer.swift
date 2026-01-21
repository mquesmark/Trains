import SwiftUI

struct Shimmer: ViewModifier {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var x: CGFloat = -1

    var duration: Double = 1.2
    var angle: Double = 20
    var bandSize: CGFloat = 0.7          // ширина полосы относительно контента
    var highlightOpacity: Double = 0.55
    var blur: CGFloat = 10

    func body(content: Content) -> some View {
        Group {
            if reduceMotion {
                content
            } else {
                content
                    .overlay {
                        GeometryReader { geo in
                            let w = geo.size.width
                            let h = geo.size.height
                            let bandW = max(1, w * bandSize)

                            LinearGradient(
                                gradient: Gradient(stops: [
                                    .init(color: .clear, location: 0.0),
                                    .init(color: .white.opacity(highlightOpacity), location: 0.5),
                                    .init(color: .clear, location: 1.0)
                                ]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                            .frame(width: bandW, height: h * 1.4)
                            .rotationEffect(.degrees(angle))
                            .offset(x: x * (w + bandW) * 1.2)
                            .blur(radius: blur)
                            .blendMode(.plusLighter)       // мягче, чем screen/overlay
                            .compositingGroup()
                        }
                    }
                    .mask(content)
                    .onAppear {
                        x = -1
                        withAnimation(.linear(duration: duration).repeatForever(autoreverses: false)) {
                            x = 1
                        }
                    }
            }
        }
    }
}

extension View {
    func shimmer(
        duration: Double = 1.2,
        angle: Double = 20,
        bandSize: CGFloat = 0.7,
        highlightOpacity: Double = 0.55,
        blur: CGFloat = 10
    ) -> some View {
        modifier(Shimmer(
            duration: duration,
            angle: angle,
            bandSize: bandSize,
            highlightOpacity: highlightOpacity,
            blur: blur
        ))
    }
}
