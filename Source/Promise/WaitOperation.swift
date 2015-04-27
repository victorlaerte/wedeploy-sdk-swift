import Foundation

class WaitOperation : Operation {

	var promise: (((Any?) -> (), (NSError) -> ()) -> ())?

	init(_ promise: (((Any?) -> (), (NSError) -> ()) -> ())? = nil) {
		self.promise = promise
	}

	override func main() {
		let group = dispatch_group_create()
		dispatch_group_enter(group)

		if (self.promise == nil) {
			let operation = self.dependencies.last as? Operation
			self.promise =
				operation?.output as! (((Any?) -> (), (NSError) -> ()) -> ())!
		}

		promise!({
			self.output = $0
			dispatch_group_leave(group)
		}, {
			self.catch?($0)
			dispatch_group_leave(group)
		})

		dispatch_group_wait(group, DISPATCH_TIME_FOREVER)
	}

}