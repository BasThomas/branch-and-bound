import XCTest

private extension Board {
  init(tiles: [[Tile]]) {
    self.init(rows: tiles.count)
    currentBoard = tiles
  }
}

class Tests: XCTestCase {

  var board: Board = .init(
    tiles: [
      [7, 4, 6, 3],
      [1, 2, 10, 5],
      [9, 14, -1, 11],
      [13, 15, 12, 8]
    ]
  )

  var videoBoard: Board = .init(
    tiles: [
      [1, 2, 3, 4],
      [5, 6, -1, 8],
      [9, 10, 7, 11],
      [13, 14, 15, 12]
    ]
  )

  func testNext() {
    videoBoard.next()
    let nextBoard: [[Board.Tile]] = [
      [1, 2, 3, 4],
      [5, 6, 7, 8],
      [9, 10, -1, 11],
      [13, 14, 15, 12]
    ]
    XCTAssertEqual(board.currentBoard, nextBoard)
  }
}
