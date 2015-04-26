import Foundation

class WaitOperation : Operation {

	var catch: ((NSError) -> ())?
	let promise: ((Any?) -> (), (NSError) -> ()) -> ()

	init(
		_ promise: (((Any?) -> (), (NSError) -> ()) -> ()),
		catch: ((NSError) -> ())? = nil) {

		self.promise = promise
		self.catch = catch
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