import Foundation

struct Board: CustomStringConvertible {
  struct Position: CustomStringConvertible, Equatable {
    let row: Int
    let column: Int

    func isAdjacent(to position: Position, in board: Board) -> Bool {
      let x = board.adjacentPositions(for: self)
        .filter { $0 == position }
        .isEmpty == false

      return x
    }

    var description: String {
      return "row: \(row), column: \(column)"
    }
  }

  enum Tile: Equatable {
    case empty
    case number(Int)

    var intValue: Int {
      switch self {
      case .empty: return -1
      case .number(let number): return number
      }
    }
  }

  let initialBoard: [[Tile]]
  var currentBoard: [[Tile]]
  private let maximumDigits: Int

  init(rows: Int) {
    precondition(rows > 1, "A puzzle should at least be 2x2")
    let maximumNumber = NSDecimalNumber(decimal: pow(Decimal(rows), 2)).intValue
    var _board: [[Tile]] = []
    for row in 0..<rows {
      _board.append([])
      for column in 0..<rows {
        let number = (row * rows) + column + 1
        if row == rows - 1 && column == rows - 1 {
          _board[row].append(.empty)
        } else {
          _board[row].append(.number(number))
        }
      }
    }

    initialBoard = _board
    currentBoard = _board
    maximumDigits = maximumNumber.digits
  }

  private func position(
    for tile: Tile
    ) -> Position {
    let tileIndex = currentBoard
      .flatMap { $0 }
      .firstIndex(of: tile)!
    let row = tileIndex % initialBoard.count
    let column = tileIndex / initialBoard.count
    return .init(row: row, column: column)
  }

  private var emptyTile: Position {
    return position(for: .empty)
  }

  private subscript(
    position: Position
  ) -> Tile {
      return currentBoard[position.column][position.row]
  }

  private func tile(
    at position: Position
    ) -> Tile {
    return self[position]
  }

  private mutating func swap(
    _ aTile: Tile,
    with bTile: Tile
  ) -> Bool {
    let aPosition = position(for: aTile)
    let bPosition = position(for: bTile)
    guard aPosition.isAdjacent(to: bPosition, in: self) else { return false }
    currentBoard[aPosition.column][aPosition.row] = bTile
    currentBoard[bPosition.column][bPosition.row] = aTile

    return true
  }

  @discardableResult
  mutating func move(
    tile: Tile
  ) -> Bool {
    guard tile != .empty else { return false }
    guard position(for: tile).isAdjacent(to: position(for: .empty), in: self) else { return false }
    return swap(tile, with: .empty)
  }

  mutating func shuffle() {
    // see https://github.com/BasThomas/Fif/blob/a0fe046b08f0153696ab52237ae93607fdc95638/Fif-tvOS/GameViewController.swift#L60
  }

  private func adjacentPositions(
    for position: Position
  ) -> [Position] {
    var adjacentPositions: [Position] = []

    var positions: [Position] {
      return initialBoard
        .flatMap { $0 }
        .map(position(for:))
    }

    for loopingPosition in positions where position != loopingPosition {
      switch loopingPosition {
      case Position(row: position.row, column: position.column - 1):
      fallthrough // above
      case Position(row: position.row - 1, column: position.column):
      fallthrough // left
      case Position(row: position.row + 1, column: position.column):
      fallthrough // below
      case Position(row: position.row, column: position.column + 1):
        precondition(adjacentPositions.contains(loopingPosition) == false)
        adjacentPositions.append(loopingPosition) // right
      default:
        continue // no match
      }
    }

    precondition(
      adjacentPositions.count <= 4,
      "Can't have more than four adjacent positions, got \(adjacentPositions)"
    )
    precondition(
      adjacentPositions.count >= 2,
      "Must have at least two adjacent positions, got \(adjacentPositions)"
    )

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
        let tile = currentBoard[column][row]
        let paddedNumber = tile.intValue.padded(
          with: " ",
          maximumDigits: maximumDigits
        )

        let formattedPaddedNumber: String
        if tile == .empty {
          formattedPaddedNumber = paddedNumber.replacingOccurrences(
            of: "-1",
            with: "  "
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
