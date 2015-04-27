import Foundation

public class Promise<T: Any> {

	var catch: ((NSError) -> ())?
	var operations = [Operation]()
	var promise: (((Any?) -> (), (NSError) -> ()) -> ())?

	init(_ block: () -> (T)) {
		_then(BlockOperation { input in
			return block()
		})
	}

	init(promise: ((T) -> (), (NSError) -> ()) -> ()) {
		self.promise = { (fulfill, reject) in
			promise({ fulfill($0) }, reject)
		}

		_then(WaitOperation(promise: self.promise!))
	}

	private init(_ operations: [Operation]) {
		self.operations = operations
	}

	public func catch(catch: (NSError) -> ()) -> Self {
		self.catch = catch

		return self
	}

	public func done() {
		let queue = NSOperationQueue()

		for operation in operations {
			operation.catch = { error in
				queue.cancelAllOperations()
				self.catch?(error)
			}
		}

		queue.addOperations(operations, waitUntilFinished: false)
	}

	public func then<U: Any>(block: (T) -> (U)) -> Promise<U> {
		_then(BlockOperation { input in
			return block(input as! T) as U
		})

		return Promise<U>(self.operations)
	}

	public func then<U: Any>(block: (T) -> (Promise<U>)) -> Promise<U> {
		_then(WaitOperation(block: { input in
			return block(input as! T).promise!
		}))

		return Promise<U>(self.operations)
	}

	private func _then(operation: Operation) {
		if let last = operations.last {
			operation.addDependency(last)
		}

		operations.append(operation)
	}

}