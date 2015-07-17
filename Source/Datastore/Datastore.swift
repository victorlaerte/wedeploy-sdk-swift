import Foundation

public class Datastore {

	public typealias FailureCallback = NSError -> ()
	public typealias SuccessArrayCallback = [[String: AnyObject]] -> ()
	public typealias SuccessDictionaryCallback = [String: AnyObject] -> ()
	public typealias SuccessStatusCodeCallback = Int -> ()

	let url: String

	init(_ url: String) {
		self.url = url
	}

	public func add(
		path: String, document: AnyObject, success: SuccessDictionaryCallback,
		failure: FailureCallback? = nil) {

		Launchpad(url).path(path).post(
			document, success: success, failure: failure)
	}

	public func get(
		path: String, id: String, success: SuccessDictionaryCallback,
		failure: FailureCallback? = nil) {

		Launchpad(url).path("\(path)/\(id)").get(success, failure: failure)
	}

	public func get(
		path: String, query: Query? = nil, success: SuccessArrayCallback,
		failure: FailureCallback? = nil) {

		Launchpad(url).path(path).params(query?.params).get(
			success, failure: failure)
	}

	public func remove(
		path: String, id: String, success: SuccessStatusCodeCallback,
		failure: FailureCallback? = nil) {

		Launchpad(url).path("\(path)/\(id)").delete(success, failure: failure)
	}

	public func update(
		path: String, id: String, document: AnyObject,
		success: SuccessDictionaryCallback, failure: FailureCallback? = nil) {

		Launchpad(url).path("\(path)/\(id)").put(
			document, success: success, failure: failure)
	}

}