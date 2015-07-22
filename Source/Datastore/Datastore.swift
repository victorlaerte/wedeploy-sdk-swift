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

	public func add(path: String, document: AnyObject)
		-> Promise<[String: AnyObject]> {

		return Promise<[String: AnyObject]>(promise: { fulfill, reject in
			let success = self.parse(fulfill, reject)

			Launchpad(self.url).path(path).post(
				document, success: success, failure: reject)
		})
	}

	public func get(path: String, id: String) -> Promise<[String: AnyObject]> {
		return Promise<[String: AnyObject]>(promise: { fulfill, reject in
			let success = self.parse(fulfill, reject)

			Launchpad(self.url).path("\(path)/\(id)").get(
				success, failure: reject)
		})
	}

	public func get(path: String, query: Query? = nil)
		-> Promise<[[String: AnyObject]]> {

		return Promise<[[String: AnyObject]]>(promise: { fulfill, reject in
			let success = self.parse(fulfill, reject)

			Launchpad(self.url).path(path).params(query?.params).get(
				success, failure: reject)
		})
	}

	public func remove(path: String, id: String) -> Promise<Response> {
		return Promise<Response>(promise: { fulfill, reject in
			Launchpad(self.url).path("\(path)/\(id)").delete(
				fulfill, failure: reject)
		})
	}

	public func update(path: String, id: String, document: AnyObject)
		-> Promise<[String: AnyObject]> {

		return Promise<[String: AnyObject]>(promise: { fulfill, reject in
			let success = self.parse(fulfill, reject)

			Launchpad(self.url).path("\(path)/\(id)").put(
				document, success: success, failure: reject)
		})
	}

	func parse<T>(fulfill: (T) -> (), _ reject: (NSError) -> ())
		-> (Response) -> () {

		return { response in
			if let body: AnyObject = response.body {
				fulfill(body as! T)
			}
		}
	}

}