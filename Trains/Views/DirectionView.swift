import SwiftUI

struct DirectionView: View {
    @State var fromText: String? = nil
    @State var toText: String? = nil
    let fromPlaceholder = "Откуда"
    let toPlaceholder = "Куда"
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.blueUniversal)
            HStack {
                VStack(alignment: .leading, spacing: 0) {
                    Text(fromText ?? fromPlaceholder)
                        .font(.system(size: 17, weight: .regular))
                        .foregroundStyle(fromText == nil ? .grayUniversal : .black)
                        .padding(16)
                    Text(toText ?? toPlaceholder)
                        .font(.system(size: 17, weight: .regular))
                        .foregroundStyle(toText == nil ? .grayUniversal : .black)
                        .padding(16)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                .padding(16)
                Button {
                    
                } label: {
                    Image("change")
                }
                .padding(.trailing)
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 120)
    }
}

#Preview {
    DirectionView()
}
