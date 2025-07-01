import Foundation
#if os(macOS)
import AppKit
#endif
#if os(Windows)
import WinSDK
#endif

/// Opens a URL using the appropriate platform API.
func openExternalURL(_ url: URL) {
#if os(Windows)
    url.absoluteString.withCString(encodedAs: UTF16.self) { lpFile in
        "open".withCString(encodedAs: UTF16.self) { lpOperation in
            _ = ShellExecuteW(nil, lpOperation, lpFile, nil, nil, SW_SHOWNORMAL)
        }
    }
#else
    NSWorkspace.shared.open(url)
#endif
}

#if os(Windows)
/// Executes a PowerShell script and returns its standard output.
func runPowerShellScript(_ script: String) -> String? {
    let fileURL = FileManager.default.temporaryDirectory
        .appendingPathComponent(UUID().uuidString + ".ps1")
    do {
        try script.write(to: fileURL, atomically: true, encoding: .utf8)
    } catch {
        return nil
    }
    defer { try? FileManager.default.removeItem(at: fileURL) }

    let process = Process()
    process.executableURL = URL(fileURLWithPath: "powershell.exe")
    process.arguments = ["-NoProfile", "-NonInteractive", "-ExecutionPolicy", "Bypass", "-File", fileURL.path]
    let pipe = Pipe()
    process.standardOutput = pipe
    do {
        try process.run()
    } catch {
        return nil
    }
    process.waitUntilExit()
    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    return String(data: data, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines)
}
#endif
