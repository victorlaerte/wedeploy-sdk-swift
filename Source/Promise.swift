import Foundation

public class Promise {

	var operations = [NSOperation]()

	init(_ block: () -> (Any?)) {
		operations.append(PromiseOperation(block: { input in
			block()
		}))
	}

	public func then(empty: () -> ()) -> Self {
		_then({ input in
			empty()
		})

		return self
	}

	public func then(#both: (Any?) -> (Any?)) -> Self {
		_then(both)

		return self
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