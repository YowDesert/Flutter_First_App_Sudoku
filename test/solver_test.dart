import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_sudoku/models/board.dart';
import 'package:flutter_sudoku/sudoku/solver.dart';

void main() {
  test('solver counts solutions correctly', () {
    Board b = Board(0);
    // fill one cell conflict
    b.at(0, 0).value = 1;
    b.at(0, 1).value = 1; // illegal
    Solver solver = Solver();
    expect(solver.countSolutions(b), 0);
  });

  test('empty board has many solutions but limit works', () {
    Board b = Board(0);
    Solver solver = Solver();
    expect(solver.countSolutions(b, limit: 2), 2);
  });
}
