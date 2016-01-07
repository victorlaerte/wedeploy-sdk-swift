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

	var launchpad: Launchpad {
		return Launchpad(server).path(path)
	}

	var path: String!
	var server: String!

	override func setUp() {
		loadSettings()
		deleteAllBooks()

		for bookToAdd in booksToAdd {
			let expectation = expect("setUp")

			launchpad
				.post(bookToAdd)
				.then { response in
					self.books.append(response.body as! [String: AnyObject])
					expectation.fulfill()
				}
			.done()

			wait()
		}
	}

	override func tearDown() {
		deleteAllBooks()
	}

	func assertBook(expected: [String: AnyObject], response: Response)
		-> [String: AnyObject]? {

		XCTAssertTrue(response.succeeded)

		guard let book = response.body as? [String: AnyObject] else {
			XCTFail("Response body could not be converted to a book")
			return nil
		}

		assertBook(expected, book: book)

		return book
	}

	func assertBooks(expected: [[String: NSObject]], response: Response)
		-> [[String: AnyObject]]? {

		XCTAssertTrue(response.succeeded)

		guard let books = response.body as? [[String: AnyObject]] else {
			XCTFail("Response body could not be converted to array of books")
			return nil
		}

		if (expected.count != books.count) {
			XCTFail("Number of books on the server is different than expected")
			return nil
		}

		for (index, book) in books.enumerate() {
			assertBook(expected[index], book: book)
		}

		return books
	}

	private func assertBook(
		expected: [String: AnyObject], book: [String: AnyObject]) {

		XCTAssertEqual(expected["title"] as? String, book["title"] as? String)
	}

	private func deleteAllBooks() {
		let expectation = expect("tearDown")

		launchpad
			.delete()
			.then { status -> () in
				expectation.fulfill()
			}
		.done()

		wait()
	}

	private func loadSettings() {
		let bundle = NSBundle(identifier: "com.liferay.Launchpad.Tests")
		let file = bundle!.pathForResource("settings", ofType: "plist")
		let settings = NSDictionary(contentsOfFile: file!) as! [String: String]

		path = settings["path"]
		server = settings["server"]
	}

}