import Foundation

class BlockOperation : Operation {

	var block: ((Any?) -> (Any?))

	init(_ block: (Any?) -> (Any?)) {
		self.block = block
	}

	override func main() {
		let operation = self.dependencies.last as? Operation
		self.output = block(operation?.output)
	}

}