import SwiftUI

struct ContentView: View {
    private let client = LSPClient()
    @State private var rootPathString = ""

    var body: some View {
        Form {
            Section(header: Text("Initialization")) {
                TextField(
                    "Project root path",
                    text: $rootPathString
                )
                Button("Send Initialize Request") {
                    client.sendInitializeRequest(projectRootPathString: rootPathString)
                }
            }
        } // VStack
        .padding()
        .frame(width: 800)
    } // body
}

#Preview {
    ContentView()
}
