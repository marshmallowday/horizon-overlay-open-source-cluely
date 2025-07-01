#if os(Windows)
import SwiftWin32
import WinSDK
// WinSparkleManager provides update integration

/// A simple Quick Capture overlay replicated for Windows using SwiftWin32.
/// This mirrors the macOS `QuickCaptureWindow` structure with a text field
/// and a save button.
final class QuickCaptureWindowWin: Window {
    private let textField: TextField
    private let saveButton: Button

    init() {
        // Set the frame similar to the macOS overlay dimensions
        let frame = Rect(x: 100, y: 100, width: 721, height: 80)
        self.textField = TextField(frame: Rect(x: 20, y: 20, width: 600, height: 32))
        self.saveButton = Button(frame: Rect(x: 630, y: 20, width: 70, height: 32),
                                 primaryAction: Action(title: "Save") { _ in
            // Placeholder for note save action
            MessageBoxW(nil, "Note saved".wide, "Quick Capture".wide, UINT(MB_OK))
        })
        super.init(frame: frame)
        self.title = "Quick Capture"
        self.backgroundColor = .systemBackground
        self.addSubview(textField)
        self.addSubview(saveButton)
    }
}

/// Entry point used when running on Windows.
@main
final class QuickCaptureApp: ApplicationDelegate, SceneDelegate {
    var window: Window!

    func application(_ application: Application,
                     didFinishLaunchingWithOptions options: [Application.LaunchOptionsKey : Any]?) -> Bool {
        WinSparkleManager.initialize()
        WinSparkleManager.checkForUpdates()
        return true
    }

    func applicationWillTerminate(_ application: Application) {
        WinSparkleManager.cleanUp()
    }

    func sceneDidLoad(_ scene: Scene) {
        window = QuickCaptureWindowWin()
        window.show()
    }
}
#endif
