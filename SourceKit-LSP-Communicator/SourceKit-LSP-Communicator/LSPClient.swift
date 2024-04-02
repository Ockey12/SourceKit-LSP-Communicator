import Foundation
import LanguageServerProtocol
import LanguageServerProtocolJSONRPC

final class LSPClient {
    private let clientToServer = Pipe()
    private let serverToClient = Pipe()
    private let serverProcess = Process()
    private lazy var connection = JSONRPCConnection(
        protocol: .lspProtocol,
        inFD: .init(fileDescriptor: serverToClient.fileHandleForReading.fileDescriptor),
        outFD: .init(fileDescriptor: clientToServer.fileHandleForWriting.fileDescriptor)
    )
    private let queue = DispatchQueue(label: "LSP-Request")
    private let serverPath = "/Applications/Xcode-15.2.0.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/sourcekit-lsp"

    func sendInitializeRequest(projectRootPathString: String) {
        connection.start(receiveHandler: Client())

        serverProcess.launchPath = serverPath
        serverProcess.standardInput = clientToServer
        serverProcess.standardOutput = serverToClient
        serverProcess.terminationHandler = { [weak self] _ in
            self?.connection.close()
        }
        serverProcess.launch()

        let rootURL = URL(fileURLWithPath: projectRootPathString)
        let request = InitializeRequest(
            rootURI: DocumentURI(string: rootURL.deletingLastPathComponent().absoluteString),
            capabilities: ClientCapabilities(),
            workspaceFolders: nil
        )

        dump(request, name: "InitializeRequest")
        print("")

        _ = connection.send(
            request,
            queue: queue,
            reply: { result in
                switch result {
                case .success(let response):
                    print("\nINITIALIZATION SUCCEEDED\n")
                    dump(response)
                case .failure(let error):
                    print("\nINITIALIZATION FAILED...\n")
                    print(error)
                }
            }
        )
    } // func sendInitializeRequest

    func sendInitializedNotification() {
        connection.send(InitializedNotification())
    }
}

private final class Client: MessageHandler {
    func handle<Notification>(
        _: Notification,
        from: ObjectIdentifier
    ) where Notification : NotificationType {}

    func handle<Request>(
        _: Request,
        id: RequestID,
        from: ObjectIdentifier,
        reply: @escaping (LSPResult<Request.Response>) -> Void
    ) where Request : RequestType {}
}
