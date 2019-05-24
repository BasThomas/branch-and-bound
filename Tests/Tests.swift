import XCTest

private extension Board {
  init(tiles: [[Tile]]) {
    self.init(rows: tiles.count)
    currentBoard = tiles
  }

  static func solved(rows: Int) -> Board {
    return .init(rows: rows)
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

  var videoBoard: Board!

  override func setUp() {
    super.setUp()
    videoBoard = .init(
      tiles: [
        [1, 2, 3, 4],
        [5, 6, -1, 8],
        [9, 10, 7, 11],
        [13, 14, 15, 12]
      ]
    )
  }

  func testNext() {
    videoBoard.next()
    let nextBoard: [[Board.Tile]] = [
      [1, 2, 3, 4],
      [5, 6, 7, 8],
      [9, 10, -1, 11],
      [13, 14, 15, 12]
    ]
    XCTAssertEqual(videoBoard.currentBoard, nextBoard)
  }

  func testSolve() {
    let solution = videoBoard.solve()
    XCTAssertEqual(videoBoard.currentBoard, Board.solved(rows: 4).currentBoard)
    for step in solution {
      print(step.step)
    }
  }
}
