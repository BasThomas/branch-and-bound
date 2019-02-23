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
    // mutate currentBoard here
  }

  mutating func shuffle() {
    // see https://github.com/BasThomas/Fif/blob/a0fe046b08f0153696ab52237ae93607fdc95638/Fif-tvOS/GameViewController.swift#L60
  }

  private func adjacentPositions(for position: Position) -> [Position] {
    // see https://github.com/BasThomas/Fif/blob/a0fe046b08f0153696ab52237ae93607fdc95638/Shared/UICollectionView%2BExtension.swift#L13
    var adjacentPositions: [Position] = []
    adjacentPositions.append(.init(row: 0, column: 0))
    adjacentPositions.append(.init(row: 0, column: 0))
    // FIXME: all adjacent positions must be unique
    precondition(adjacentPositions.count <= 4, "Can't have more than four adjacent positions")
    precondition(adjacentPositions.count >= 2, "Must have at least two adjacent positions")

    return adjacentPositions
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
