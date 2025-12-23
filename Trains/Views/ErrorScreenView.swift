import SwiftUI

struct ErrorScreenView: View {
    
    enum ErrorType {
        case serverError
        case noInternet
    }
    
    let errorType: ErrorType
    
    var image: Image {
        switch errorType {
        case .noInternet:
            return Image(.noInternet)
        case .serverError:
            return Image(.serverError)
            
        }
    }
    
    var text: String {
        switch errorType {
        case .noInternet:
            return "Нет интернета"
        case .serverError:
            return "Ошибка сервера"
        }
    }
    
    var body: some View {
        ZStack {
            Color.backgroundYP
                .ignoresSafeArea()
            VStack {
                image
                    .padding(.bottom, 16)
                Text(text)
                    .font(.system(size: 24, weight: .bold))
            }
        }
    }
}

#Preview {
    ErrorScreenView(errorType: .noInternet)
}
#Preview {
    ErrorScreenView(errorType: .noInternet)
        .preferredColorScheme(.dark)
}
