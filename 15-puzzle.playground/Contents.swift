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

struct Board: CustomPlaygroundDisplayConvertible {
  let board: [[Int]]
  private let maximumDigits: Int

  init(rows: Int) {
    precondition(rows > 1, "A puzzle should at least be 2x2")
    let maximumNumber = NSDecimalNumber(decimal: pow(Decimal(rows), 2)).intValue
    let randomNumber = Int.random(in: 1...maximumNumber)
    var _board: [[Int]] = []
    for column in 0..<rows {
      _board.append([])
      for row in 0..<rows {
        let number = (column * rows) + row + 1
        if number == randomNumber {
          // append one random "0" tile; representing the empty tile
          _board[column].append(0)
        } else {
          _board[column].append(number)
        }
      }
    }

    board = _board
    maximumDigits = maximumNumber.digits
  }

  var playgroundDescription: Any {
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
print(five.playgroundDescription)
