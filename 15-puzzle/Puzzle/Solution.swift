import Foundation

struct Solution<Problem>: Collection {
  struct Step<T> {
    let step: T
  }

  let steps: [Step<Problem>]

  var input: Step<Problem> {
    return steps.first! // safe, as steps will guaranteed to be larger than 0.
  }

  var output: Step<Problem> {
    return steps.last! // safe, as steps will guaranteed to be larger than 0.
  }

  init(steps: [Step<Problem>]) {
    precondition(steps.count > 0, "Solution must contain at least one step.")
    self.steps = steps
  }

  init(steps: Step<Problem>...) {
    self.init(steps: steps)
  }

  var startIndex: Int {
    return steps.startIndex
  }

  var endIndex: Int {
    return steps.endIndex
  }

  subscript(i: Int) -> Step<Problem> {
    return steps[i]
  }

  func index(after i: Int) -> Int {
    return steps.index(after: i)
  }
}
