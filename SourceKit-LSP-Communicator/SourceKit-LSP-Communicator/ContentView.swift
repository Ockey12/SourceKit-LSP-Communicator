import SwiftUI

struct ContentView: View {
    private let client = LSPClient()
    @State private var rootPathString = ""
    @State private var sourceFilePath = ""
    @State private var sourceCode = ""
    @State private var selectedLine = 1
    @State private var selectedUtf16Index = 1

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

            Section(header: Text("Definition Jump")) {
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

                HStack {
                    Picker("Line", selection: $selectedLine) {
                        ForEach(1...100, id: \.self) { number in
                            Text("\(number)")
                        }
                    }
                    .frame(width: 100)

                    Picker("utf16index", selection: $selectedUtf16Index) {
                        ForEach(1...100, id: \.self) { number in
                            Text("\(number)")
                        }
                    }
                    .frame(width: 130)
                } // HStack

                Button("Send Definition Request") {
                    client.sendDefinitionRequest(
                        sourceFilePathString: sourceFilePath,
                        position: .init(
                            line: selectedLine - 1,
                            utf16index: selectedUtf16Index - 1
                        )
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
