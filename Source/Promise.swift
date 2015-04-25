import Foundation

public class Promise {

	var operations = [NSOperation]()

	init(_ block: (Any?) -> (Any?)) {
		operations.append(PromiseOperation(block: block))
	}

	public func then(block: (Any?) -> (Any?)) -> Self {
		let last = operations.last! as! PromiseOperation
		let operation = PromiseOperation(block: block)

		operation.addDependency(last)
		operations.append(operation)

		return self
	}

	public func done() {
		let queue = NSOperationQueue()

		queue.addOperations(operations, waitUntilFinished: false)
	}

}