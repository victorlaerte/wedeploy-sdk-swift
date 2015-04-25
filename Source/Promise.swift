import Foundation

public class Promise<T: Any> {

	var operations = [NSOperation]()

	init(_ block: () -> (T?)) {
		operations.append(PromiseOperation(block: { input in
			return block()
		}))
	}

	public func then(empty: () -> ()) -> Self {
		then(both: { input in
			empty()
			return nil
		})

		return self
	}

	public func then(#both: (T?) -> (T?)) -> Self {
		let b: (Any?) -> (Any?) = { input in
			return both(input as! T?) as T?
		}

		let operation = PromiseOperation(block: b)
		let last = operations.last! as! PromiseOperation

		operation.addDependency(last)
		operations.append(operation)

		return self
	}

	public func done() {
		let queue = NSOperationQueue()
		queue.addOperations(operations, waitUntilFinished: false)
	}

}