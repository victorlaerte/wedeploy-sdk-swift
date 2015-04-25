import Foundation

public class Promise<T: Any> {

	var catch: ((NSError) -> ())!
	var onCatch: ((NSError) -> ())?
	var operations = [NSOperation]()
	var queue: NSOperationQueue?

	init() {
		self.catch = { error in
			self.queue!.cancelAllOperations()
			self.onCatch?(error)
		}
	}

	convenience init(_ block: () -> (T?)) {
		self.init()

		_then({ input in
			return block()
		})
	}

	convenience init(_ promise: ((T) -> (), (NSError) -> ()) -> ()) {
		self.init()

		_then({ input in
			promise({ input in }, self.catch)
		})
	}

	private init(_ operations: [NSOperation]) {
		self.operations = operations
	}

	public func catch(catch: (NSError) -> ()) -> Self {
		self.onCatch = catch

		return self
	}

	public func done() {
		queue = NSOperationQueue()
		queue!.addOperations(operations, waitUntilFinished: false)
	}

	public func then(empty: () -> ()) -> Self {
		_then({ input in
			empty()
			return nil
		})

		return self
	}

	public func then(#block: (T?) -> (T?)) -> Self {
		_then({ input in
			return block(input as! T?) as T?
		})

		return self
	}

	public func then<U>(#block: (T?) -> (U?)) -> Promise<U> {
		_then({ input in
			return block(input as! T?) as U?
		})

		return Promise<U>(self.operations)
	}

	private func _then(block: (Any?) -> (Any?)) {
		let operation = PromiseOperation(block: block)

		if let last = operations.last as? PromiseOperation {
			operation.addDependency(last)
		}

		operations.append(operation)
	}

}