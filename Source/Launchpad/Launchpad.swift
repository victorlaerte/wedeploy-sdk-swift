import Foundation

public class Launchpad {

	var headers: [String: String]
	var params: [NSURLQueryItem]
	var path: String
	var transport: Transport
	var url: String

	init(_ url: String) {
		self.transport = NSURLSessionTransport()
		self.url = url
		self.path = ""
		self.headers = [:]
		self.params = [NSURLQueryItem]()
	}

	public enum Verb: String {
		case DELETE = "DELETE", GET = "GET", PATCH = "PATCH", POST = "POST",
		PUT = "PUT"
	}

	public func delete(
		success: (Response -> ()), failure: (NSError -> ())? = nil) {

		transport.send(
			.DELETE, url: url, path: path, params: params, headers: headers,
			body: nil, success: success, failure: failure)
	}

	public func get(
		success: (Response -> ()), failure: (NSError -> ())? = nil) {

		transport.send(
			.GET, url: url, path: path, params: params, headers: headers,
			body: nil, success: success, failure: failure)
	}

	public func header(name: String, _ value: String) -> Self {
		headers[name] = value

		return self
	}

	public func param(name: String, _ value: String) -> Self {
		params.append(NSURLQueryItem(name: name, value: value))

		return self
	}

	public func params(params: [NSURLQueryItem]?) -> Self {
		if let p = params {
			self.params = p
		}

		return self
	}

	public func patch(
		body: AnyObject, success: (Response -> ()),
		failure: (NSError -> ())? = nil) {

		transport.send(
			.PATCH, url: url, path: path, params: params, headers: headers,
			body: body, success: success, failure: failure)
	}

	public func path(path: String) -> Self {
		self.path = path

		return self
	}

	public func post(
		body: AnyObject, success: (Response -> ()),
		failure: (NSError -> ())? = nil) {

		transport.send(
			.POST, url: url, path: path, params: params, headers: headers,
			body: body, success: success, failure: failure)
	}

	public func put(
		body: AnyObject, success: (Response -> ()),
		failure: (NSError -> ())? = nil) {

		transport.send(
			.PUT, url: url, path: path, params: params, headers: headers,
			body: body, success: success, failure: failure)
	}

	public func use(transport: Transport) -> Self {
		self.transport = transport

		return self
	}

}