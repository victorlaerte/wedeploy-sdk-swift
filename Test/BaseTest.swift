import Launchpad
import XCTest

class BaseTest : XCTestCase {

	var books = [[String: AnyObject]]()

	var booksToAdd = [
		[
			"title": "Cien años de soledad",
			"year": 1967
		],
		[
			"title": "Historias de cronopios y de famas",
			"year": 1962
		]
	]

	var datastore: Datastore!
	var launchpad: Launchpad!
	var path: String!
	var server: String!

	override func setUp() {
		loadSettings()

		launchpad = Launchpad(server)
		datastore = Datastore(server)

		for bookToAdd in booksToAdd {
			let expectation = expect("setUp")

			datastore
				.add(path, document: bookToAdd)
				.then { book -> () in
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

			Launchpad(server)
				.path(path)
				.path("/\(id)")
				.delete()
				.then { status -> () in
					expectation.fulfill()
				}
			.done()

			wait()
		}
	}

	func assertBook(expected: [String: AnyObject], book: [String: AnyObject]) {
		XCTAssertEqual(
			expected["title"] as? String, book["title"] as? String)
	}

	func assertBook(expected: [String: AnyObject], response: Response) {
		XCTAssertTrue(response.succeeded)

		guard let book = response.body as? [String: AnyObject] else {
			XCTFail("Response body could not be converted to a book")
			return
		}

		assertBook(expected, book: book)
	}

	func assertBooks(
		expected: [[String: NSObject]], books: [[String: AnyObject]]) {

		if (expected.count != books.count) {
			XCTFail("Number of books on the server is different than expected")
			return
		}

		for (index, book) in books.enumerate() {
			assertBook(expected[index], book: book)
		}
	}

	func assertBooks(expected: [[String: NSObject]], response: Response) {
		XCTAssertTrue(response.succeeded)

		guard let books = response.body as? [[String: AnyObject]] else {
			XCTFail("Response body could not be converted to array of books")
			return
		}

		assertBooks(expected, books: books)
	}

	private func loadSettings() {
		let bundle = NSBundle(identifier: "com.liferay.Launchpad.Tests")
		let file = bundle!.pathForResource("settings", ofType: "plist")
		let settings = NSDictionary(contentsOfFile: file!) as! [String: String]

		path = settings["path"]
		server = settings["server"]
	}

}