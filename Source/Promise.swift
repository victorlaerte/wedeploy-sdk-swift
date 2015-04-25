import Foundation

public class Promise<T: Any> {

	var operations = [NSOperation]()

	init(_ block: () -> (T?)) {
		operations.append(PromiseOperation(block: { input in
			return block()
		}))
	}

	private init(_ operations: [NSOperation]) {
		self.operations = operations
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

	public func done() {
		let queue = NSOperationQueue()
		queue.addOperations(operations, waitUntilFinished: false)
	}

	private func _then(block: (Any?) -> (Any?)) {
		let operation = PromiseOperation(block: block)
		let last = operations.last! as! PromiseOperation

		operation.addDependency(last)
		operations.append(operation)
	}

}