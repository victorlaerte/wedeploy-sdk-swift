import Foundation

public class Promise<T: Any> {

	var catch: ((NSError) -> ())?
	var operations = [Operation]()
	var queue: NSOperationQueue?

	init(_ block: () -> (T?)) {
		_then(BlockOperation { input in
			return block()
		})
	}

	init(_ promise: ((Any?) -> (), (NSError) -> ()) -> ()) {
		let catch: ((NSError) -> ()) = { error in
			self.queue!.cancelAllOperations()
			self.catch?(error)
		}

		_then(WaitOperation(promise, catch))
	}

	private init(_ operations: [Operation]) {
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
		_then(BlockOperation { input in
			empty()
			return nil
		})

		return self
	}

	public func then(#block: (T?) -> (T?)) -> Self {
		_then(BlockOperation { input in
			return block(input as! T?) as T?
		})

		return self
	}

	public func then<U>(#block: (T?) -> (U?)) -> Promise<U> {
		_then(BlockOperation { input in
			return block(input as! T?) as U?
		})

		return Promise<U>(self.operations)
	}

	private func _then(operation: Operation) {
		if let last = operations.last {
			operation.addDependency(last)
		}

		operations.append(operation)
	}

}