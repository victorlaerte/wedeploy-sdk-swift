import Foundation

public class Promise<T: Any> {

	var catch: ((NSError) -> ())?
	var operations = [Operation]()
	var queue: NSOperationQueue?

	init(_ block: () -> (T)) {
		_then(BlockOperation { input in
			return block()
		})
	}

	init(_ promise: ((T?) -> (), (NSError) -> ()) -> ()) {
		let catch: ((NSError) -> ()) = { error in
			self.queue!.cancelAllOperations()
			self.catch?(error)
		}

		let p: ((Any?) -> (), (NSError) -> ()) -> () = { (fulfill, reject) in
			promise({ fulfill($0) }, reject)
		}

		_then(WaitOperation(p, catch))
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

	public func then<U>(block: (T) -> (U)) -> Promise<U> {
		_then(BlockOperation { input in
			return block(input as! T) as U
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