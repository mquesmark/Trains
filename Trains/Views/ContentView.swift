import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
        .onAppear {
            APITests.testNearestStationsService()
            APITests.testNearestSettlementService()
            APITests.testCarrierService()
            APITests.testCopyrightService()
            APITests.testScheduleService()
            APITests.testSearchService()
            APITests.testStationsListService()
            APITests.testThreadService()
        }
    }
}

#Preview {
    ContentView()
}
