import SwiftUI

struct ContentView: View {
    private let client = LSPClient()
    @State private var rootPathString = ""
    @State private var sourceFilePath = ""
    @State private var sourceCode = ""

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

                Button("Send Initialized Notification") {
                    client.sendInitializedNotification()
                }
            } // Section "Initialization"

            Section(header: Text("DidOpen")) {
                TextField(
                    "Source file path",
                    text: $sourceFilePath
                )

                TextEditor(text: $sourceCode)
                    .frame(height: 300)

                Button("Send DidOpen Notification") {
                    client.sendDidOpenNotification(
                        sourceFilePathString: sourceFilePath,
                        sourceCode: sourceCode
                    )
                }
            } // section "DidOpen"
        } // VStack
        .padding()
        .frame(width: 800)
    } // body
}

#Preview {
    ContentView()
}
