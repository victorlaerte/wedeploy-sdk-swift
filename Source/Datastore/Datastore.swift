import Foundation
import later

public class Datastore {

	public typealias FailureCallback = NSError -> ()
	public typealias SuccessArrayCallback = [[String: AnyObject]] -> ()
	public typealias SuccessDictionaryCallback = [String: AnyObject] -> ()
	public typealias SuccessStatusCodeCallback = Int -> ()

	let url: String

	public init(_ url: String) {
		self.url = url
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