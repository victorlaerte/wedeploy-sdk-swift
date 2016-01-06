import Foundation

public class Launchpad {

	var headers: [String: String] = [:]
	var params: [NSURLQueryItem] = [NSURLQueryItem]()
	var path: String = ""
	var transport: Transport = NSURLSessionTransport()
	var _url: String

	var url: String {
		return _url + path
	}

	public init(_ url: String) {
		self._url = url
	}

	public func delete(
		success: (Response -> ()), failure: (NSError -> ())? = nil) {

		let request = Request(
			method: Request.Verb.DELETE, headers: headers, url: url,
			params: params)

		transport.send(request, success: success, failure: failure)
	}

	public func get(
		success: (Response -> ()), failure: (NSError -> ())? = nil) {

		let request = Request(headers: headers, url: url, params: params)

		transport.send(request, success: success, failure: failure)
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

		let request = Request(
			method: Request.Verb.PATCH, headers: headers, url: url,
			params: params, body: body)

		transport.send(request, success: success, failure: failure)
	}

	public func path(path: String) -> Self {
		self.path += path

		return self
	}

	public func post(
		body: AnyObject, success: (Response -> ()),
		failure: (NSError -> ())? = nil) {

		let request = Request(
			method: Request.Verb.POST, headers: headers, url: url,
			params: params, body: body)

		transport.send(request, success: success, failure: failure)
	}

	public func put(
		body: AnyObject, success: (Response -> ()),
		failure: (NSError -> ())? = nil) {

		let request = Request(
			method: Request.Verb.PUT, headers: headers, url: url,
			params: params, body: body)

		transport.send(request, success: success, failure: failure)
	}

	public func use(transport: Transport) -> Self {
		self.transport = transport

		return self
	}

}