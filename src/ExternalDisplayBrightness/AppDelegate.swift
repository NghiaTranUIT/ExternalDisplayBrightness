import AppKit

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
	var preferencesWindowController: PreferencesWindowController?
	
	func applicationWillFinishLaunching(_ notification: Notification) {
		// don't put the "Enter Full Screen" menu item into the View submenu, there are no windows to put to fullscreen
		UserDefaults.standard.set(false, forKey: "NSFullScreenMenuItemEverywhere")
	}
	
	func applicationDidFinishLaunching(_: Notification) {
		UserDefaults.standard.register(defaults: [
			"decreaseBrightnessKey": "F14",
			"increaseBrightnessKey": "F15",
			"changeBrightnessOnAllDisplaysAtOnce": 1,
			"changeBrightnessOnAllDisplaysAtOnceRequiresCommand": 1,
			"showPreferencesOnNextLaunch": true,
		])
		
        _ = BrightnessManager.shared
		self.preferencesWindowController = PreferencesWindowController()
		self.showPreferencesWindow(self)
	}
	
	// show the preferences window when the user tries to launch the app and it's already running
	func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
		self.activateApp(ignoringOtherApps: true)
		// display the preferences window after a short delay, otherwise there is a chance we will not own the menubar
		DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(150)) { self.showPreferencesWindow(sender) }
		
		return false
	}
	
	@IBAction private func showPreferencesWindow(_ sender: Any?) {
		self.preferencesWindowController?.showWindow(sender)
	}
	
	@IBAction private func showAboutPanel(_ sender: Any?) {
		let link = "https://www.nesveda.com/projects/ExternalDisplayBrightness/"
		let credits = NSAttributedString(string: link, attributes: [.link: NSURL(string: link) ?? ""])
		NSApplication.shared.orderFrontStandardAboutPanel(options: [.credits: credits])
	}
	
	// relaunch app pretending the user opened it themselves, so it doesn't inherit the permissions of the current instance of the app
	@IBAction private func relaunchApp(_ sender: Any?) {
		let shellPath = "/bin/sh"
		let shellArgs = ["-c", "sleep 1; /usr/bin/open \"\(Bundle.main.bundlePath)\""]
		
		if (try? Process.run(URL(fileURLWithPath: shellPath), arguments: shellArgs)) != nil {
			NSApplication.shared.terminate(self)
		}
	}
	
	// show the main menu and Dock icon
	func activateApp(ignoringOtherApps force: Bool = false) {
		NSApplication.shared.activate(ignoringOtherApps: true)
	}

}
