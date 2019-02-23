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
  let board: [[Int]]
  private let maximumDigits: Int

  init(rows: Int) {
    precondition(rows > 1, "A puzzle should at least be 2x2")
    let maximumNumber = NSDecimalNumber(decimal: pow(Decimal(rows), 2)).intValue
    let randomNumber = Int.random(in: 1...maximumNumber)
    var _board: [[Int]] = []
    for row in 0..<rows {
      _board.append([])
      for column in 0..<rows {
        let number = (row * rows) + column + 1
        if number == randomNumber {
          // append one random "0" tile; representing the empty tile
          _board[row].append(0)
        } else {
          _board[row].append(number)
        }
      }
    }

    board = _board
    maximumDigits = maximumNumber.digits
  }

  var emptyTile: (column: Int, row: Int) {
    let zeroTileIndex = board
      .flatMap { $0 }.firstIndex(of: 0)!
    let column = zeroTileIndex / board.count
    let row = zeroTileIndex % board.count
    return (column, row)
  }

  var description: String {
    var res = ""
    for column in 0..<board.count {
      for row in 0..<board[column].count {
        // prepend each row with a pipe, so all numbers are "encased" in them,
        // ie. |1|2|3|.
        if row == 0 { res.append("|") }
        let number = board[column][row]
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
