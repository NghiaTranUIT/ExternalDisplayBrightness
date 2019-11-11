import AppKit

// Controls the preferences window
class PreferencesWindowController: NSWindowController, NSWindowDelegate {

    @IBOutlet weak var brightnessStepper: NSStepper!

	// needed to access the singleton from Interface Builder
	@objc dynamic weak var sharedLoginItemManager = LoginItemManager.shared
	@objc dynamic var isPrivileged: Bool {
		return AXIsProcessTrusted()
	}
	
	override var windowNibName: NSNib.Name? {
		return "PreferencesWindow"
	}
	
	override func windowDidLoad() {
		super.windowDidLoad()
		self.window?.center()
	}
	
	override func showWindow(_ sender: Any?) {
		if !(self.window?.isVisible ?? true) {
			self.window?.center()
		}
		super.showWindow(sender)
		UserDefaults.standard.set(false, forKey: "showPreferencesOnNextLaunch")
	}
	
	func windowWillClose(_: Notification) {
        
	}
	
	func windowDidUpdate(_: Notification) {
		LoginItemManager.shared.updateEnabled()
	}
	
    @IBAction func increaseOnChange(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name("increaseBrightnessNoti"), object: nil)
    }

    @IBAction func desceaseOnChange(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name("decreaseBrightnessNoti"), object: nil)
    }
}
