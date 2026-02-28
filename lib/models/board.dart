import 'cell.dart';

class Board {
  final List<List<Cell>> grid;

  Board(int seed)
    : grid = List.generate(9, (_) => List.generate(9, (_) => Cell()));

  Board.clone(Board other)
    : grid = other.grid
          .map(
            (r) => r.map((c) => Cell(value: c.value, given: c.given)).toList(),
          )
          .toList();

  Cell at(int row, int col) => grid[row][col];

  bool isValidMove(int row, int col, int val) {
    if (val < 1 || val > 9) return false;
    for (int i = 0; i < 9; i++) {
      if (i != col && grid[row][i].value == val) return false;
      if (i != row && grid[i][col].value == val) return false;
    }
    int br = (row ~/ 3) * 3, bc = (col ~/ 3) * 3;
    for (int r = br; r < br + 3; r++)
      for (int c = bc; c < bc + 3; c++)
        if ((r != row || c != col) && grid[r][c].value == val) return false;
    return true;
  }

  bool get isComplete => grid.expand((r) => r).every((c) => c.value != 0);

  /// mark given cells after puzzle created
  void markGiven() {
    for (var r in grid) {
      for (var c in r) {
        if (c.value != 0) c.given = true;
      }
    }
  }
}
