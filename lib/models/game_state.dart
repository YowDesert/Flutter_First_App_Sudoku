import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../sudoku/difficulty.dart';
import '../sudoku/generator.dart';
import 'board.dart';

enum Mode { normal, notes }

class GameState extends ChangeNotifier {
  static const int maxHealth = 100;
  static const int hintHealthCost = 5;

  final SharedPreferences prefs;
  final Set<String> _revealedHintTargets = <String>{};

  Board? puzzle;
  Board? solution;
  int selectedRow = -1;
  int selectedCol = -1;
  Mode mode = Mode.normal;
  int combo = 0;
  int score = 0;
  int health = maxHealth;
  int mistakes = 0;
  bool showErrors = false;
  int hintsUsed = 0;
  DateTime startTime = DateTime.now();
  Difficulty difficulty = Difficulty.easy;
  String lastMessage = '';

  GameState(this.prefs);

  void newGame({required Difficulty diff, DateTime? seedDate}) {
    difficulty = diff;
    final seed =
        seedDate?.millisecondsSinceEpoch ?? DateTime.now().millisecondsSinceEpoch;
    final gen = Generator(seed);
    puzzle = gen.generate(diff);
    solution = gen.solution;
    startTime = DateTime.now();
    combo = 0;
    score = 0;
    health = maxHealth;
    mistakes = 0;
    hintsUsed = 0;
    selectedRow = -1;
    selectedCol = -1;
    lastMessage = '';
    _revealedHintTargets.clear();
    notifyListeners();
  }

  void select(int r, int c) {
    if (puzzle == null) return;
    if (puzzle!.at(r, c).given) return;
    selectedRow = r;
    selectedCol = c;
    notifyListeners();
  }

  void toggleMode() {
    mode = mode == Mode.normal ? Mode.notes : Mode.normal;
    notifyListeners();
  }

  void toggleErrors() {
    showErrors = !showErrors;
    notifyListeners();
  }

  void input(int val) {
    if (puzzle == null || solution == null) return;
    if (selectedRow < 0 || selectedCol < 0) return;

    final cell = puzzle!.at(selectedRow, selectedCol);
    if (cell.given) return;

    if (mode == Mode.notes) {
      if (cell.notes.contains(val)) {
        cell.notes.remove(val);
      } else {
        cell.notes.add(val);
      }
      notifyListeners();
      return;
    }

    final correctValue = solution!.at(selectedRow, selectedCol).value;
    if (val == correctValue) {
      cell.value = val;
      cell.notes.clear();
      combo += 1;
      score += _scoreForCorrectMove();
      lastMessage = '';
      checkCompletion();
    } else {
      mistakes += 1;
      combo = 0;
      score = max(0, score - 3);
      lastMessage = '這格不是正確數字';
    }
    notifyListeners();
  }

  void erase() {
    if (puzzle == null) return;
    if (selectedRow < 0 || selectedCol < 0) return;

    final cell = puzzle!.at(selectedRow, selectedCol);
    if (cell.given) return;
    cell.value = 0;
    cell.notes.clear();
    notifyListeners();
  }

  void checkCompletion() {
    if (puzzle == null) return;
    if (puzzle!.isComplete || health == 0) {
      // handled by UI listener
    }
  }

  bool hintA() {
    if (puzzle == null || solution == null) return false;
    if (!_canUseHint()) {
      lastMessage = '血量不足，不能再使用提示';
      notifyListeners();
      return false;
    }

    final row = selectedRow;
    final col = selectedCol;
    if (row < 0 || col < 0) {
      lastMessage = '請先選一格再使用提示';
      notifyListeners();
      return false;
    }

    final cell = puzzle!.at(row, col);
    if (cell.value != 0) {
      lastMessage = '這格已經有數字了';
      notifyListeners();
      return false;
    }

    final revealed = _revealHintFor(row, col);
    if (revealed) {
      _applyHintCost();
      notifyListeners();
    }
    if (!revealed) {
      lastMessage = '這格相關提示都已經顯示過了';
      notifyListeners();
    }
    return revealed;
  }

  bool hintB() {
    if (puzzle == null || solution == null) return false;
    if (!_canUseHint()) {
      lastMessage = '血量不足，不能再使用提示';
      notifyListeners();
      return false;
    }

    for (int r = 0; r < 9; r++) {
      for (int c = 0; c < 9; c++) {
        final cell = puzzle!.at(r, c);
        if (cell.value != 0) continue;

        if (_revealHintFor(r, c)) {
          _applyHintCost();
          selectedRow = r;
          selectedCol = c;
          notifyListeners();
          return true;
        }
      }
    }

    lastMessage = '沒有新的提示可以顯示';
    notifyListeners();
    return false;
  }

  bool _canUseHint() => health >= hintHealthCost;

  void _applyHintCost() {
    hintsUsed += 1;
    health = max(0, health - hintHealthCost);
    combo = 0;
    score = max(0, score - 5);
    checkCompletion();
  }

  bool _revealHintFor(int row, int col) {
    final target = solution!.at(row, col).value;
    final boxIndex = (row ~/ 3) * 3 + (col ~/ 3);
    final candidates = <String>[
      'row:$row:$target',
      'col:$col:$target',
      'box:$boxIndex:$target',
    ];

    for (final candidate in candidates) {
      if (_revealedHintTargets.contains(candidate)) {
        continue;
      }

      _revealedHintTargets.add(candidate);
      lastMessage = _buildHintMessage(candidate, row, col, target);
      return true;
    }

    return false;
  }

  String _buildHintMessage(String candidate, int row, int col, int target) {
    if (candidate.startsWith('row:')) {
      return '第 ${row + 1} 行有數字 $target';
    }
    if (candidate.startsWith('col:')) {
      return '第 ${col + 1} 列有數字 $target';
    }
    return '第 ${(row ~/ 3) + 1} 個宮格列、第 ${(col ~/ 3) + 1} 個宮格欄有數字 $target';
  }

  int _scoreForCorrectMove() {
    late final int baseScore;
    switch (difficulty) {
      case Difficulty.easy:
        baseScore = 10;
        break;
      case Difficulty.medium:
        baseScore = 15;
        break;
      case Difficulty.hard:
        baseScore = 20;
        break;
    }
    final comboBonus = min(combo - 1, 5) * 2;
    return baseScore + comboBonus;
  }

  Map<String, dynamic> getResult() {
    final dur = DateTime.now().difference(startTime);
    return {
      'time': dur.inSeconds,
      'score': score,
      'hints': hintsUsed,
      'health': health,
      'combo': combo,
      'mistakes': mistakes,
    };
  }

  void saveRecord() {
    final currentBest = bestScore();
    if (score > currentBest) {
      prefs.setInt('best_${difficulty.name}_score', score);
    }
  }

  int bestScore() => prefs.getInt('best_${difficulty.name}_score') ?? 0;
}
