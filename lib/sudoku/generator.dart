import 'dart:math';
import '../models/board.dart';
import 'solver.dart';
import 'difficulty.dart';

class Generator {
  final Random _rand;
  Board? solution;

  Generator(int seed) : _rand = Random(seed);

  Board generate(Difficulty diff) {
    Board b = Board(0);
    _fill(b);
    solution = Board.clone(b);

    // dig holes
    int holes = diff == Difficulty.easy
        ? 40
        : diff == Difficulty.medium
        ? 50
        : 60;
    List<int> cells = List.generate(81, (i) => i)..shuffle(_rand);
    Solver solver = Solver();
    for (int idx in cells) {
      if (holes == 0) break;
      int r = idx ~/ 9, c = idx % 9;
      int backup = b.at(r, c).value;
      b.at(r, c).value = 0;
      if (solver.countSolutions(b) == 1) {
        holes--;
      } else {
        b.at(r, c).value = backup;
      }
    }
    b.markGiven();
    return b;
  }

  bool _fill(Board b) {
    for (int r = 0; r < 9; r++) {
      for (int c = 0; c < 9; c++) {
        if (b.at(r, c).isEmpty) {
          List<int> vals = List.generate(9, (i) => i + 1)..shuffle(_rand);
          for (int v in vals) {
            if (b.isValidMove(r, c, v)) {
              b.at(r, c).value = v;
              if (_fill(b)) return true;
              b.at(r, c).value = 0;
            }
          }
          return false;
        }
      }
    }
    return true;
  }
}
