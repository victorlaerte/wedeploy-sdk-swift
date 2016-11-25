import Foundation

public protocol Transport {

	func send(
		request: Request, success: @escaping ((Response) -> ()), failure: @escaping (Error) -> ())

}

public class NSURLSessionTransport : Transport {

	public func send(
		request: Request, success: @escaping ((Response) -> ()), failure: @escaping (Error) -> ()) {

		let success = dispatchMainThread(success)
		let failure = dispatchMainThread(failure)
        
		let config = URLSessionConfiguration.ephemeral
		let session = URLSession(configuration: config)

		do {
			let request = try request.toURLRequest()

			session.dataTask(with:
				request,
				completionHandler: { (data, r, error) in
					if let e = error {
						failure(e)
						return
					}

					let httpURLResponse = r as! HTTPURLResponse
					let headerFields = httpURLResponse.allHeaderFields
					var headers = [String: String]()

					for (key, value) in headerFields {
						headers[key.description] = value as? String
					}

					let response = Response(
						statusCode: httpURLResponse.statusCode,
						headers: headers, body: data!)

					success(response)
				}
			).resume()
		}
		catch let e as NSError {
			failure(e)
			return
		}
	}

	func dispatchMainThread<T>(_ block: @escaping (T) -> ()) -> (T) -> () {
		return { value in

			DispatchQueue.main.async {
				block(value)
			}
		}
	}

}
