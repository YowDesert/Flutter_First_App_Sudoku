import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/game_controller.dart';
import '../../models/app_enums.dart';
import '../../models/sudoku_puzzle.dart';
import '../theme/game_theme.dart';

class BoardWidget extends StatelessWidget {
  const BoardWidget({
    super.key,
    this.lockSquare = true,
  });

  final bool lockSquare;

  @override
  Widget build(BuildContext context) {
    final boardPalette = GameTheme.board(context);
    final board =
        context.select<GameController, _BoardRenderData?>((controller) {
      final session = controller.session;
      if (session == null) return null;
      return _BoardRenderData(
        puzzle: session.puzzle,
        values: session.values,
        notes: session.notes,
        selectedIndex: session.selectedIndex,
        visibleErrorIndexes: controller.visibleErrorIndexes,
        recentErrorIndex: controller.recentErrorIndex,
        feedbackVersion: controller.feedbackVersion,
      );
    });
    if (board == null) {
      return const SizedBox.shrink();
    }

    final selectedIndex = board.selectedIndex;
    final selectedValue =
        selectedIndex == null ? 0 : board.values[selectedIndex];
    final selectedCell =
        selectedIndex == null ? null : CellPosition.fromIndex(selectedIndex);

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth <= 0 || constraints.maxHeight <= 0) {
          return const SizedBox.shrink();
        }

        final boardWidth = constraints.maxWidth;
        final boardHeight = lockSquare
            ? math.min(constraints.maxWidth, constraints.maxHeight)
            : constraints.maxHeight;
        final boardSide = math.min(boardWidth, boardHeight);
        final cellSize = boardSide / 9;
        final valueFont = (cellSize * 0.47).clamp(17.0, 31.0);
        final noteFont = (cellSize * 0.17).clamp(8.0, 12.0);
        final notePadding = (cellSize * 0.075).clamp(3.0, 5.0);

        return Center(
          child: Container(
            width: boardSide,
            height: boardSide,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  boardPalette.panelGradientTop,
                  boardPalette.panelGradientBottom,
                ],
              ),
              border: Border.all(color: boardPalette.panelBorder, width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: boardPalette.panelShadow,
                  blurRadius: 28,
                  offset: Offset(0, 14),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(22),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Column(
                      children: List.generate(9, (row) {
                        return Expanded(
                          child: Row(
                            children: List.generate(9, (col) {
                              final index = row * 9 + col;
                              final value = board.values[index];
                              final isSelected = selectedIndex == index;
                              final isGiven = board.puzzle.isGiven(index);
                              final isError =
                                  board.visibleErrorIndexes.contains(index);
                              final isRecentError =
                                  board.recentErrorIndex == index && value != 0;
                              final sameRowCol = selectedCell != null &&
                                  (selectedCell.row == row ||
                                      selectedCell.col == col) &&
                                  !isSelected;
                              final sameBox = selectedCell != null &&
                                  (selectedCell.row ~/ 3 == row ~/ 3 &&
                                      selectedCell.col ~/ 3 == col ~/ 3) &&
                                  !isSelected;
                              final sameValue = selectedValue != 0 &&
                                  value != 0 &&
                                  value == selectedValue &&
                                  !isSelected;

                              final background = _resolveCellBackground(
                                palette: boardPalette,
                                row: row,
                                col: col,
                                selected: isSelected,
                                sameRowCol: sameRowCol,
                                sameBox: sameBox,
                                sameValue: sameValue,
                                isError: isError,
                              );

                              return Expanded(
                                child: TweenAnimationBuilder<double>(
                                  key: ValueKey(
                                    'cell-$index-${isRecentError ? board.feedbackVersion : 0}',
                                  ),
                                  duration: const Duration(milliseconds: 320),
                                  tween: Tween<double>(
                                    begin: 0,
                                    end: isRecentError ? 1 : 0,
                                  ),
                                  builder: (context, shake, child) {
                                    final dx = isRecentError
                                        ? math.sin(shake * math.pi * 5.2) * 4.5
                                        : 0.0;
                                    return Transform.translate(
                                      offset: Offset(dx, 0),
                                      child: child,
                                    );
                                  },
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: () => context
                                          .read<GameController>()
                                          .selectCell(row, col),
                                      splashColor: boardPalette.tapSplash,
                                      highlightColor: Colors.transparent,
                                      child: AnimatedContainer(
                                        duration:
                                            const Duration(milliseconds: 170),
                                        curve: Curves.easeOutCubic,
                                        color: background,
                                        child: Stack(
                                          fit: StackFit.expand,
                                          children: [
                                            Center(
                                              child: AnimatedSwitcher(
                                                duration: const Duration(
                                                    milliseconds: 170),
                                                transitionBuilder:
                                                    (child, animation) {
                                                  final curved =
                                                      CurvedAnimation(
                                                    parent: animation,
                                                    curve: Curves.easeOutCubic,
                                                  );
                                                  return FadeTransition(
                                                    opacity: curved,
                                                    child: ScaleTransition(
                                                      scale: Tween<double>(
                                                        begin: 0.9,
                                                        end: 1,
                                                      ).animate(curved),
                                                      child: child,
                                                    ),
                                                  );
                                                },
                                                child: value != 0
                                                    ? Text(
                                                        '$value',
                                                        key: ValueKey(
                                                            'value-$index-$value'),
                                                        style: TextStyle(
                                                          fontSize: valueFont,
                                                          fontWeight: isGiven
                                                              ? FontWeight.w900
                                                              : FontWeight.w800,
                                                          color: isError
                                                              ? boardPalette
                                                                  .errorDigit
                                                              : isGiven
                                                                  ? boardPalette
                                                                      .givenDigit
                                                                  : boardPalette
                                                                      .userDigit,
                                                        ),
                                                      )
                                                    : _NotesGrid(
                                                        key: ValueKey(
                                                          'note-$index-${_notesSignature(board.notes[index])}',
                                                        ),
                                                        notes:
                                                            board.notes[index],
                                                        fontSize: noteFont,
                                                        padding: notePadding,
                                                        active: isSelected ||
                                                            sameRowCol,
                                                      ),
                                              ),
                                            ),
                                            IgnorePointer(
                                              child: AnimatedOpacity(
                                                duration: const Duration(
                                                    milliseconds: 120),
                                                opacity: isSelected ? 1 : 0,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(1.3),
                                                  child: DecoratedBox(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              7),
                                                      border: Border.all(
                                                        color: boardPalette
                                                            .selectedBorder,
                                                        width: 2,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),
                        );
                      }),
                    ),
                    IgnorePointer(
                      child: CustomPaint(
                        painter: _GridPainter(
                          thinColor: boardPalette.gridThin,
                          thickColor: boardPalette.gridThick,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  static String _notesSignature(Set<int> notes) {
    if (notes.isEmpty) return '0';
    final digits = notes.toList()..sort();
    return digits.join();
  }

  Color _resolveCellBackground({
    required BoardPalette palette,
    required int row,
    required int col,
    required bool selected,
    required bool sameRowCol,
    required bool sameBox,
    required bool sameValue,
    required bool isError,
  }) {
    var color = (row + col).isEven ? palette.cellEven : palette.cellOdd;

    if (sameRowCol) {
      color = Color.alphaBlend(palette.sameRowColOverlay, color);
    }
    if (sameBox) {
      color = Color.alphaBlend(palette.sameBoxOverlay, color);
    }
    if (sameValue) {
      color = Color.alphaBlend(palette.sameValueOverlay, color);
    }
    if (selected) {
      color = palette.selectedCell;
    }
    if (isError) {
      color = Color.alphaBlend(palette.errorOverlay, color);
    }
    return color;
  }
}

class _GridPainter extends CustomPainter {
  const _GridPainter({
    required this.thinColor,
    required this.thickColor,
  });

  final Color thinColor;
  final Color thickColor;

  @override
  void paint(Canvas canvas, Size size) {
    final thinPaint = Paint()
      ..color = thinColor
      ..strokeWidth = 0.8;
    final thickPaint = Paint()
      ..color = thickColor
      ..strokeWidth = 1.9;

    final cell = size.width / 9;
    for (var i = 1; i < 9; i++) {
      final position = cell * i;
      final isMajor = i % 3 == 0;
      final paint = isMajor ? thickPaint : thinPaint;
      canvas.drawLine(
          Offset(position, 0), Offset(position, size.height), paint);
      canvas.drawLine(Offset(0, position), Offset(size.width, position), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _GridPainter oldDelegate) {
    return oldDelegate.thinColor != thinColor ||
        oldDelegate.thickColor != thickColor;
  }
}

class _NotesGrid extends StatelessWidget {
  const _NotesGrid({
    super.key,
    required this.notes,
    required this.fontSize,
    required this.padding,
    required this.active,
  });

  final Set<int> notes;
  final double fontSize;
  final double padding;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final boardPalette = GameTheme.board(context);
    final noteColor =
        active ? boardPalette.noteActive : boardPalette.noteInactive;
    return Padding(
      padding: EdgeInsets.all(padding),
      child: Column(
        children: List.generate(3, (r) {
          return Expanded(
            child: Row(
              children: List.generate(3, (c) {
                final digit = (r * 3) + c + 1;
                final visible = notes.contains(digit);
                return Expanded(
                  child: Center(
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 110),
                      opacity: visible ? 1 : 0,
                      child: Text(
                        '$digit',
                        style: TextStyle(
                          fontSize: fontSize,
                          fontWeight: FontWeight.w800,
                          color: noteColor,
                          height: 1.0,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          );
        }),
      ),
    );
  }
}

class _BoardRenderData {
  const _BoardRenderData({
    required this.puzzle,
    required this.values,
    required this.notes,
    required this.selectedIndex,
    required this.visibleErrorIndexes,
    required this.recentErrorIndex,
    required this.feedbackVersion,
  });

  final SudokuPuzzle puzzle;
  final List<int> values;
  final List<Set<int>> notes;
  final int? selectedIndex;
  final Set<int> visibleErrorIndexes;
  final int? recentErrorIndex;
  final int feedbackVersion;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is _BoardRenderData &&
        identical(puzzle, other.puzzle) &&
        identical(values, other.values) &&
        identical(notes, other.notes) &&
        selectedIndex == other.selectedIndex &&
        identical(visibleErrorIndexes, other.visibleErrorIndexes) &&
        recentErrorIndex == other.recentErrorIndex &&
        feedbackVersion == other.feedbackVersion;
  }

  @override
  int get hashCode => Object.hash(
        identityHashCode(puzzle),
        identityHashCode(values),
        identityHashCode(notes),
        selectedIndex,
        identityHashCode(visibleErrorIndexes),
        recentErrorIndex,
        feedbackVersion,
      );
}
