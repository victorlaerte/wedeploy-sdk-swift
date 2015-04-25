import Foundation

public class Promise {

	var operations = [NSOperation]()

	public func then(block: () -> ()) -> Self {
		let operation = NSBlockOperation(block: block)

		if let last = operations.last {
			operation.addDependency(last)
		}

		operations.append(operation)

		return self
	}

	public func done() {
		let queue = NSOperationQueue()

		queue.addOperations(operations, waitUntilFinished: false)
	}

}