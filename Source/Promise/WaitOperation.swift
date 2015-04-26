import Foundation

class WaitOperation : Operation {

	let promise: ((Any?) -> (), (NSError) -> ()) -> ()

	init(_ promise: (((Any?) -> (), (NSError) -> ()) -> ())) {
		self.promise = promise
	}

	override func main() {
		let group = dispatch_group_create()
		dispatch_group_enter(group)

		promise({
			self.output = $0
			dispatch_group_leave(group)
		}, {
			self.catch?($0)
			dispatch_group_leave(group)
		})

		dispatch_group_wait(group, DISPATCH_TIME_FOREVER)
	}

}