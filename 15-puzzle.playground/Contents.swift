import Foundation

extension Int {
  var digits: Int {
    // FIXME: test multiple implementations and their speed
    return String(self).count
  }

  func padded(
    with padCharacter: Character,
    maximumDigits: Int
  ) -> String {
    let digits = self.digits
    let countOrZero = Swift.max(0, (maximumDigits - digits))
    let padCharacters = String(
      repeating: padCharacter,
      count: countOrZero
    )
    return "\(padCharacters)\(self)"
  }
}

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

struct Board: CustomStringConvertible {
  struct Position: CustomStringConvertible, Equatable {
    let row: Int
    let column: Int

    func isAdjacent(to position: Position, in board: Board) -> Bool {
      return board.adjacentPositions(for: self)
        .filter { $0 == position }
        .isEmpty == false

      // return board.adjacentPosition(for: self).allSatisfy { $0 == position } == false
    }

    var description: String {
      return "row: \(row), column: \(column)"
    }
  }

  let initialBoard: [[Int]]
  var currentBoard: [[Int]]
  private let maximumDigits: Int

  init(rows: Int) {
    precondition(rows > 1, "A puzzle should at least be 2x2")
    let maximumNumber = NSDecimalNumber(decimal: pow(Decimal(rows), 2)).intValue
    let randomNumber = Int.random(in: 1...maximumNumber)
    var _board: [[Int]] = []
    var emptyTileAdded = false
    for row in 0..<rows {
      _board.append([])
      for column in 0..<rows {
        let number = (row * rows) + column + 1
        if number == randomNumber {
          // append one random "0" tile; representing the empty tile
          _board[row].append(0)
          emptyTileAdded = true
        } else if emptyTileAdded == false {
          _board[row].append(number)
        } else if emptyTileAdded == true {
          _board[row].append(number - 1)
        } else {
          fatalError("Invalid state for \(Position(row: row, column: column))")
        }
      }
    }

    initialBoard = _board
    currentBoard = _board
    maximumDigits = maximumNumber.digits
  }

  var emptyTile: Position {
    let zeroTileIndex = currentBoard
      .flatMap { $0 }.firstIndex(of: 0)!
    let row = zeroTileIndex % initialBoard.count
    let column = zeroTileIndex / initialBoard.count
    return .init(row: row, column: column)
  }

  mutating func swap(position: Position, with newPosition: Position) {
    // see https://github.com/BasThomas/Fif/blob/a0fe046b08f0153696ab52237ae93607fdc95638/Shared/UICollectionView%2BExtension.swift#L41
    #warning("mutate currentBoard here")
  }

  mutating func shuffle() {
    // see https://github.com/BasThomas/Fif/blob/a0fe046b08f0153696ab52237ae93607fdc95638/Fif-tvOS/GameViewController.swift#L60
  }

  private func adjacentPositions(for position: Position) -> [Position] {
    // see https://github.com/BasThomas/Fif/blob/a0fe046b08f0153696ab52237ae93607fdc95638/Shared/UICollectionView%2BExtension.swift#L13
    var adjacentPositions: [Position] = []
    adjacentPositions.append(.init(row: 0, column: 0))
    adjacentPositions.append(.init(row: 0, column: 0))
    #warning("all adjacent positions must be unique")
    precondition(adjacentPositions.count <= 4, "Can't have more than four adjacent positions")
    precondition(adjacentPositions.count >= 2, "Must have at least two adjacent positions")

    return adjacentPositions
  }

  @discardableResult
  func solve() -> Solution<Board> {
    #warning("implement")
    return .init()
  }

  var isCompleted: Bool {
    #warning("implement")
    return false
  }

  var description: String {
    var res = ""
    for column in 0..<currentBoard.count {
      for row in 0..<currentBoard[column].count {
        // prepend each row with a pipe, so all numbers are "encased" in them,
        // ie. |1|2|3|.
        if row == 0 { res.append("|") }
        let number = currentBoard[column][row]
        let paddedNumber = number.padded(
          with: " ",
          maximumDigits: maximumDigits
        )

        let formattedPaddedNumber: String
        if number == 0 {
          // replace the "0" tile with a space, not just any that contain a 0,
          // like 10 or 105.
          formattedPaddedNumber = paddedNumber.replacingOccurrences(
            of: "0",
            with: " "
          )
        } else {
          formattedPaddedNumber = paddedNumber
        }
        res.append("\(formattedPaddedNumber)|")
      }
      res.append("\n")
    }
    return res
  }
}

let five = Board(rows: 4)
print(five)
five.emptyTile

struct Vector<T> {
  let size: Int
  let initialValue: T

  struct Position: Equatable {
    let row: Int
    let column: Int
  }

  typealias Matrix = [Position]

  let matrix: Matrix

  init(size: Int, initialValue: T) {
    self.size = size
    self.initialValue = initialValue
    var _matrix: Matrix = []
    for row in 0..<size {
      for column in 0..<size {
        _matrix.append(.init(row: row, column: column))
      }
    }
    self.matrix = _matrix
  }
}

extension Vector: Equatable where T: Equatable {}

let threeVector = Vector<Int>.init(size: 3, initialValue: 0)
threeVector.matrix
