import Launchpad
import XCTest

class BaseTest : XCTestCase {

	var username: String!
	var password: String!
	var userId: String!

	var authModuleUrl: String!
	var emailModuleUrl: String!

	override func setUp() {
		loadSettings()
	}

	private func loadSettings() {
		let bundle = Bundle(identifier: "com.liferay.Launchpad.Tests")
		let file = bundle!.path(forResource: "settings", ofType: "plist")
		let settings = NSDictionary(contentsOfFile: file!) as! [String: String]

		username = settings["username"]
		password = settings["password"]
		userId = settings["userId"]

		authModuleUrl = settings["authModuleUrl"]
		emailModuleUrl = settings["emailModuleUrl"]
	}

	func executeAuthenticated(block: @escaping () -> ()) {
		WeDeploy.auth(authModuleUrl)
			.signInWith(username: username, password: password)
			.done { _, _ in
				block()
		}
	}
}
