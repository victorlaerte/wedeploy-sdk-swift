import Foundation

public class Promise<T: Any> {

	var catch: ((NSError) -> ())?
	var operations = [NSOperation]()
	var queue: NSOperationQueue?

	init(_ block: () -> (T?)) {
		_then({ input in
			return block()
		})
	}

	init(_ promise: ((T) -> (), (NSError) -> ()) -> ()) {
		let catch: ((NSError) -> ()) = { error in
			self.queue!.cancelAllOperations()
			self.catch?(error)
		}

		_then({ input in
			promise({ input in }, catch)
		})
	}

	private init(_ operations: [NSOperation]) {
		self.operations = operations
	}

	public func catch(catch: (NSError) -> ()) -> Self {
		self.catch = catch

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