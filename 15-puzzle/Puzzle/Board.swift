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

  enum Tile: Equatable, ExpressibleByIntegerLiteral {
    case empty
    case number(Int)

    private static let emptyValue = -1

    init(integerLiteral value: Int) {
      if value == Tile.emptyValue {
        self = .empty
      } else {
        self = .number(value)
      }
    }

    var intValue: Int {
      switch self {
      case .empty: return Tile.emptyValue
      case .number(let number): return number
      }
    }
  }

  let initialBoard: [[Tile]]
  var currentBoard: [[Tile]]
  private let maximumDigits: Int
  private let rows: Int

  /// Initializes a new board in its solved state.
  ///
  /// - Parameter rows: the amount of rows for the board.
  init(
    rows: Int
  ) {
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
    self.rows = rows
  }

  private var _previousNextTile: Tile = .empty
  mutating func next() {
    let currentBoard = self.currentBoard
    let adjacentToEmpty = adjacentPositions(for: position(for: .empty))

    let boardOptions = adjacentToEmpty.map { position -> (board: [[Tile]], moved: Tile, validPositions: Int) in
      let tileToMove = tile(at: position)
      move(tile: tileToMove)
      defer { self.currentBoard = currentBoard }
      return (self.currentBoard, tileToMove, validPositions)
    }.filter { $0.moved != _previousNextTile }
//    print(boardOptions.map { ($0.moved, $0.validPositions)})

    let amountOfValidPositionsList = boardOptions.map { $0.validPositions }
    let largestAmountOfValidPositions = amountOfValidPositionsList.max()
    precondition(largestAmountOfValidPositions != nil, "No maximum valid positions found in \(boardOptions)")
    let nextBestSteps = amountOfValidPositionsList.filter { $0 == largestAmountOfValidPositions }
//    print("next best steps:", nextBestSteps)
//    precondition(nextBestSteps.count == 1, "Should always have just one next best step, got \(nextBestSteps.count): \(nextBestSteps)")
    let bestStepIndex = boardOptions.firstIndex { $0.validPositions == nextBestSteps.first }
    precondition(bestStepIndex != nil, "Should always have an index for the next best step")

    let bestOption = boardOptions[bestStepIndex!]
    self.currentBoard = bestOption.board
    _previousNextTile = bestOption.moved
  }

  /// Returns the position of the given tile from the `currentBoard`.
  ///
  /// - Parameter tile: the tile to return the position of.
  /// - Returns: the position of the specified tile.
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

  /// Returns the position of the empty tile.
  private var emptyTile: Position {
    return position(for: .empty)
  }

  /// Returns the tile at the specified position.
  ///
  /// - Parameter position: the position to return the tile of.
  /// - Returns: the tile at the specified position.
  private func tile(
    at position: Position
  ) -> Tile {
    return currentBoard[position.column][position.row]
  }

  /// Swaps two tiles iff they are adjacent.
  ///
  /// - Parameters:
  ///   - aTile: the first tile to swap.
  ///   - bTile: the second tile to swap.
  /// - Returns: if swapping succeeded, returns `true`, otherwise `false`.
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

  /// Moves the given tile iff it is a valid move.
  /// It does not support moving the empty tile.
  ///
  /// - Parameter tile: the tile to move.
  /// - Returns: `true` iff the move was valid, and thus performed. Will not
  /// move any tiles if the move is not valid.
  @discardableResult mutating func move(
    tile: Tile
  ) -> Bool {
    guard tile != .empty else { return false }
    guard position(for: tile).isAdjacent(to: position(for: .empty), in: self) else { return false }
    return swap(tile, with: .empty)
  }

  private var _previouslyShuffledTile: Tile = .empty
  /// Shuffles the board's `currentBoard`.
  ///
  /// - Parameter moves: the amount of moves to make. Defaults to 50.
  /// The shuffling will never undo a previous move.
  mutating func shuffle(moves: Int = 50) {
    for _ in 1...moves {
      let adjacentToEmpty = adjacentPositions(for: position(for: .empty))
      precondition(adjacentToEmpty.count >= 2, "Should always have at least two adjacent empty positions")
      // Remove the previously moved tile, so we do not move a tile
      // back-and-forth. That would be rather pointless.
      let adjacentWithoutPrevious = adjacentToEmpty.filter { $0 != position(for: _previouslyShuffledTile) }
      let randomAdjacent = adjacentWithoutPrevious.randomElement()!
      let randomTile = tile(at: randomAdjacent)
      move(tile: randomTile)
      _previouslyShuffledTile = randomTile
    }
  }

  /// Calculates positions adjacent to the given position.
  ///
  /// - Parameter position: the position to check adjacent positions of.
  /// - Returns: the positions that are adjacent to the given position.
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

  /// Solves the board's `currentBoard`.
  ///
  /// - Returns: a `Solution` containing the steps necessary to solve the board.
  @discardableResult mutating func solve() -> Solution<Board> {
    var boards: [Board] = []
    repeat {
      next()
      boards.append(self); print(self)
    } while isSolved == false
    return Solution(steps: boards.map(Solution.Step.init))
  }

  /// Returns the amount of valid positions of the board's `currentBoard`.
  private var validPositions: Int {
    let currentLayout = currentBoard
      .flatMap { $0 }
      .map { $0.intValue }
    return currentLayout
      .enumerated()
      .filter {
        // While not ideal, we check for the last element and compare that to
        // minus one, the `intValue` for the `.empty` Tile.
        if $0.offset == currentLayout.endIndex - 1 {
          return $0.element == -1
        } else {
          return ($0.offset + 1) == $0.element
        }
      }.count
  }

  /// Returns `true` iff all tiles are in their valid positions.
  /// Evaluates the state for `currentBoard`.
  var isSolved: Bool {
    return validPositions == rows * rows
  }

  /// Returns a `print`-friendly, padded description of the `currentBoard`.
  ///
  /// ```
  /// | 1| 2| 3| 4|
  /// | 5| 6| 7| 8|
  /// | 9|10|11|  |
  /// |13|14|15|12|
  /// ```
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
