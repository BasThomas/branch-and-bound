import Foundation

struct Solution<Problem>: Sequence, IteratorProtocol {
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

  private var _index: Int? = nil
  mutating func next() -> Step<Problem>? {
    // we're counting up (looping though the steps array), so begin at _index 0.
    if _index == nil { _index = 0 }
    // shadow _index so we do not have to deal with its optionality
    // this is also why the "other" index is underscored.
    var index = _index!
    if index < steps.count {
      // always move the _index forward after we can return a step
      defer { _index! += 1 }
      return steps[index]
    } else {
      // when we're done, reset the _index to nil.
      _index = nil
      return nil
    }
  }
}
