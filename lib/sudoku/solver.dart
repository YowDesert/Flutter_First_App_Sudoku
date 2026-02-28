import '../models/board.dart';

class Solver {
  /// solve board in-place; return true if solved.
  bool solve(Board b) {
    for (int r = 0; r < 9; r++) {
      for (int c = 0; c < 9; c++) {
        if (b.at(r, c).isEmpty) {
          for (int v = 1; v <= 9; v++) {
            if (b.isValidMove(r, c, v)) {
              b.at(r, c).value = v;
              if (solve(b)) return true;
              b.at(r, c).value = 0;
            }
          }
          return false;
        }
      }
    }
    return true;
  }

  /// count solutions up to [limit]; stops when reached.
  int countSolutions(Board b, {int limit = 2}) {
    int count = 0;
    void dfs(Board cur) {
      if (count >= limit) return;
      for (int r = 0; r < 9; r++) {
        for (int c = 0; c < 9; c++) {
          if (cur.at(r, c).isEmpty) {
            for (int v = 1; v <= 9; v++) {
              if (cur.isValidMove(r, c, v)) {
                cur.at(r, c).value = v;
                dfs(cur);
                cur.at(r, c).value = 0;
              }
            }
            return;
          }
        }
      }
      count++;
    }

    dfs(Board.clone(b));
    return count;
  }
}
