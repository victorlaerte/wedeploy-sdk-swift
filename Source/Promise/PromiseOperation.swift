import Foundation

class PromiseOperation : NSOperation {

	var block: ((Any?) -> (Any?))?
	var output: Any?

	init(block: (Any?) -> (Any?)) {
		self.block = block
	}

	override func main() {
		let input = self.dependencies.last as? PromiseOperation
		self.output = block?(input?.output)
	}

}