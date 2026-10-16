import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            ContentUnavailableView(
                "__DISPLAY_NAME__",
                systemImage: "hammer",
                description: Text("Nothing here yet.")
            )
            .navigationTitle("__DISPLAY_NAME__")
        }
    }
}

#Preview {
    ContentView()
}
