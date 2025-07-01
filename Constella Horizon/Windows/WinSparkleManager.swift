#if os(Windows)
import WinSDK

@_silgen_name("win_sparkle_init")
func win_sparkle_init()
@_silgen_name("win_sparkle_cleanup")
func win_sparkle_cleanup()
@_silgen_name("win_sparkle_check_update_with_ui")
func win_sparkle_check_update_with_ui()

/// Simple wrapper around WinSparkle C API for Swift usage.
enum WinSparkleManager {
    static func initialize() {
        win_sparkle_init()
    }

    static func cleanUp() {
        win_sparkle_cleanup()
    }

    static func checkForUpdates() {
        win_sparkle_check_update_with_ui()
    }
}
#endif
