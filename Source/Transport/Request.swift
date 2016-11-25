import Foundation

public class Request {

	var body: AnyObject?
	var headers: [String: String]
	var method: RequestMethod
	var params: [URLQueryItem]
	var url: String

	init(
		method: RequestMethod = .GET, headers: [String: String]?, url: String,
		params: [URLQueryItem]?, body: AnyObject? = nil) {

		self.method = method
		self.headers = headers ?? [:]
		self.headers["X-Requested-With"] = "api.swift"
		self.url = url
		self.params = params ?? []
		self.body = body
	}

	func setRequestBody(request: inout URLRequest) throws {
		guard let b = body else {
			return
		}

		if let stream = b as? InputStream {
			request.httpBodyStream = stream
		}
		else if let string = b as? String {
			request.httpBody = string.data(using: .utf8)
		}
		else {
			request.setValue(
				"application/json", forHTTPHeaderField: "Content-Type")

			request.httpBody = try JSONSerialization.data(withJSONObject: b)
		}
	}

	func toURLRequest() throws -> URLRequest  {
		let URL = NSURLComponents(string: url)!
		URL.queryItems = params

		var request = URLRequest(url: URL.url!)
		request.httpMethod = method.rawValue

		for (name, value) in headers {
			request.addValue(value, forHTTPHeaderField: name)
		}

		try setRequestBody(request: &request)

		return request
	}

}
