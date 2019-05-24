import Foundation

var board = Board(rows: 4)

board.shuffle(moves: 10)

let solution = board.solve()
