import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_sudoku/sudoku/generator.dart';
import 'package:flutter_sudoku/sudoku/solver.dart';
import 'package:flutter_sudoku/sudoku/difficulty.dart';

void main() {
  test('generator produces valid puzzle with unique solution', () {
    Generator g = Generator(42);
    var puzzle = g.generate(Difficulty.easy);
    Solver solver = Solver();
    int sols = solver.countSolutions(puzzle);
    expect(sols, 1);
  });
}
