import XCTest

class BaseTest : XCTestCase {

	var books = [[String: AnyObject]]()

	var booksToAdd = [
		["title": "Cien años de soledad"],
		["title": "Historias de cronopios y de famas"]
	]

	var datastore: Datastore!
	var launchpad: Launchpad!
	var path: String!
	var server: String!

	override func setUp() {
		_loadSettings()

		launchpad = Launchpad(server)
		datastore = Datastore(server)

		for bookToAdd in booksToAdd {
			let expectation = expect("setUp")

			datastore
				.add(path, document: bookToAdd)
				.then{ book -> () in
					self.books.append(book)
					expectation.fulfill()
				}
			.done()

			wait()
		}
	}

	override func tearDown() {
		for book in books {
			let expectation = expect("tearDown")
			let id = book["id"] as! String

			datastore
				.remove(path, id: id)
				.then { status -> () in
					expectation.fulfill()
				}
			.done()

			wait()
		}
	}

	func assertBook(
		expected: [String: AnyObject], result: [String: AnyObject]) {

		XCTAssertEqual(
			expected["title"] as! String, result["title"] as! String)
	}

	func assertBooks(
		expected: [[String: String]], result: [[String: AnyObject]]) {

		for (index, book) in enumerate(result) {
			assertBook(expected[index], result: book)
		}
	}

	private func _loadSettings() {
		let bundle = NSBundle(identifier: "com.liferay.launchpad.Launchpad")
		let file = bundle!.pathForResource("settings", ofType: "plist")
		let settings = NSDictionary(contentsOfFile: file!) as! [String: String]

		path = settings["path"]
		server = settings["server"]
	}

}