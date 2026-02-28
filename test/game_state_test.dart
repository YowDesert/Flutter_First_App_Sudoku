import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_sudoku/models/game_state.dart';
import 'package:flutter_sudoku/sudoku/difficulty.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  SharedPreferences.setMockInitialValues({});

  test('toggling notes and errors and tracking mistakes', () async {
    final prefs = await SharedPreferences.getInstance();
    final state = GameState(prefs);
    state.newGame(diff: Difficulty.easy);
    expect(state.mode, Mode.normal);
    state.toggleMode();
    expect(state.mode, Mode.notes);
    state.toggleMode();
    expect(state.mode, Mode.normal);

    expect(state.showErrors, false);
    state.toggleErrors();
    expect(state.showErrors, true);

    // select an empty cell
    state.select(0, 0);
    int prevMistakes = state.mistakes;
    state.input(9); // might be wrong depending on puzzle
    if (!state.puzzle!.isValidMove(0, 0, 9)) {
      expect(state.mistakes, prevMistakes + 1);
    }
  });
}
