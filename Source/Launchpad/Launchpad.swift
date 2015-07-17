import Foundation

public class Launchpad {

	var headers: [String: String]
	var path: String
	var params: [NSURLQueryItem]
	var transport: Transport
	var url: String

	init(_ url: String) {
		self.transport = Transport()
		self.url = url
		self.path = ""
		self.headers = [:]
		self.params = [NSURLQueryItem]()
	}

	public enum Verb: String {
		case DELETE = "DELETE", GET = "GET", PATCH = "PATCH", POST = "POST",
		PUT = "PUT"
	}

	public func delete<T>(success: (T -> ())?, failure: (NSError -> ())?) {
		transport.send(
			method: .DELETE, url: url, path: path, params: params,
			headers: headers, success: success, failure: failure)
	}

	public func get<T>(success: (T -> ())?, failure: (NSError -> ())?) {
		transport.send(
			method: .GET, url: url, path: path, params: params,
			headers: headers, success: success, failure: failure)
	}

	public func header(name: String, value: String) -> Self {
		headers[name] = value

		return self
	}

	public func param(name: String, value: String) -> Self {
		params.append(NSURLQueryItem(name: name, value: value))

		return self
	}

	public func params(params: [NSURLQueryItem]?) -> Self {
		if let p = params {
			self.params = p
		}

		return self
	}

	public func patch<T>(
		body: AnyObject, success: (T -> ())?, failure: (NSError -> ())?) {

		transport.send(
			method: .PATCH, url: url, path: path, params: params,
			headers: headers, body: body, success: success, failure: failure)
	}

	public func path(path: String) -> Self {
		self.path = path

		return self
	}

	public func post<T>(
		body: AnyObject, success: (T -> ())?, failure: (NSError -> ())?) {

		transport.send(
			method: .POST, url: url, path: path, params: params,
			headers: headers, body: body, success: success, failure: failure)
	}

	public func put<T>(
		body: AnyObject, success: (T -> ())?, failure: (NSError -> ())?) {

		transport.send(
			method: .PUT, url: url, path: path, params: params,
			headers: headers, body: body, success: success, failure: failure)
	}

	public func use(transport: Transport) -> Self {
		self.transport = transport

		return self
	}

}