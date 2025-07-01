#include <windows.h>
#include <functional>

// Simple Windows implementation of a global keyboard hook using SetWindowsHookEx.
// This mirrors the macOS CGEventTap logic found in InputEventManager.swift.

class InputEventManagerWin32 {
public:
    static InputEventManagerWin32& instance() {
        static InputEventManagerWin32 mgr;
        return mgr;
    }

    // Set up the low level keyboard hook.
    void setup() {
        if (!hookHandle) {
            hookHandle = SetWindowsHookExW(WH_KEYBOARD_LL, KeyboardProc, nullptr, 0);
        }
    }

    // Remove the keyboard hook.
    void cleanup() {
        if (hookHandle) {
            UnhookWindowsHookEx(hookHandle);
            hookHandle = nullptr;
        }
    }

    // Optional callback to capture the next shortcut pressed by the user.
    void setRequestCallback(std::function<bool(DWORD, DWORD)> cb) {
        requestCallback = std::move(cb);
    }

private:
    static LRESULT CALLBACK KeyboardProc(int nCode, WPARAM wParam, LPARAM lParam) {
        if (nCode == HC_ACTION && wParam == WM_KEYDOWN) {
            const KBDLLHOOKSTRUCT* info = reinterpret_cast<KBDLLHOOKSTRUCT*>(lParam);
            DWORD vk = info->vkCode;

            DWORD modifiers = 0;
            if (GetAsyncKeyState(VK_CONTROL) & 0x8000)  modifiers |= MOD_CONTROL;
            if (GetAsyncKeyState(VK_SHIFT)   & 0x8000)  modifiers |= MOD_SHIFT;
            if (GetAsyncKeyState(VK_MENU)    & 0x8000)  modifiers |= MOD_ALT;

            if (requestCallback) {
                if (requestCallback(vk, modifiers)) {
                    requestCallback = nullptr;
                    return 1; // swallow event
                }
            }

            // Example hard coded shortcuts matching the macOS defaults
            if (modifiers == (MOD_CONTROL | MOD_SHIFT)) {
                if (vk == '1') {
                    // AIAssistOverlayManager.shared.toggle()
                    return 1;
                }
                if (vk == '2') {
                    // QuickCaptureOverlay.instance.toggle()
                    return 1;
                }
                if (vk == 'O') {
                    // AutoContextOverlay.instance.toggle()
                    return 1;
                }
            }
        }
        return CallNextHookEx(hookHandle, nCode, wParam, lParam);
    }

    static HHOOK hookHandle;
    static std::function<bool(DWORD, DWORD)> requestCallback;
};

HHOOK InputEventManagerWin32::hookHandle = nullptr;
std::function<bool(DWORD, DWORD)> InputEventManagerWin32::requestCallback = nullptr;


