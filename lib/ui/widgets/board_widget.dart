import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/game_state.dart';

class BoardWidget extends StatelessWidget {
  const BoardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<GameState>();
    final board = state.puzzle;
    if (board == null) return const SizedBox();

    final hasSelection = state.selectedRow >= 0 && state.selectedCol >= 0;
    final selectedValue = hasSelection
        ? board.at(state.selectedRow, state.selectedCol).value
        : 0;

    return LayoutBuilder(
      builder: (context, constraints) {
        final boardSize = math.min(constraints.maxWidth, constraints.maxHeight);
        final cellFont = (boardSize / 20).clamp(18.0, 34.0);
        final noteFont = (boardSize / 55).clamp(8.0, 12.0);

        return Center(
          child: SizedBox(
            width: boardSize,
            height: boardSize,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: const Color(0xFFFDFEFF),
                borderRadius: BorderRadius.circular(26),
                border: Border.all(
                  color: const Color(0xFF20304A),
                  width: 3,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(22),
                child: Column(
                  children: List.generate(9, (r) {
                    return Expanded(
                      child: Row(
                        children: List.generate(9, (c) {
                          final cell = board.at(r, c);
                          final bool invalid = cell.value != 0 &&
                              !cell.given &&
                              state.showErrors &&
                              !board.isValidMove(r, c, cell.value);

                          final bool isSelected =
                              state.selectedRow == r && state.selectedCol == c;
                          final bool sameBand = state.selectedRow == r ||
                              state.selectedCol == c ||
                              ((r ~/ 3) == (state.selectedRow ~/ 3) &&
                                  (c ~/ 3) == (state.selectedCol ~/ 3));
                          final bool sameValue = selectedValue != 0 &&
                              cell.value == selectedValue;

                          var background = ((r ~/ 3) + (c ~/ 3)).isEven
                              ? const Color(0xFFF7F9FC)
                              : Colors.white;

                          if (sameBand && hasSelection) {
                            background = const Color(0xFFEAF2FF);
                          }
                          if (sameValue) {
                            background = const Color(0xFFDDEAFF);
                          }
                          if (isSelected) {
                            background = const Color(0xFFBFD5FF);
                          }
                          if (invalid) {
                            background = const Color(0xFFFFE0E0);
                          }

                          return Expanded(
                            child: GestureDetector(
                              onTap: () => state.select(r, c),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: background,
                                  border: Border(
                                    top: BorderSide(
                                      color: r == 0
                                          ? const Color(0xFF20304A)
                                          : const Color(0xFFB9C4D5),
                                      width: r == 0
                                          ? 0
                                          : (r % 3 == 0 ? 2.2 : 0.7),
                                    ),
                                    left: BorderSide(
                                      color: c == 0
                                          ? const Color(0xFF20304A)
                                          : const Color(0xFFB9C4D5),
                                      width: c == 0
                                          ? 0
                                          : (c % 3 == 0 ? 2.2 : 0.7),
                                    ),
                                    right: BorderSide(
                                      color: c == 8
                                          ? const Color(0xFF20304A)
                                          : const Color(0xFFB9C4D5),
                                      width: c == 8 ? 0 : 0,
                                    ),
                                    bottom: BorderSide(
                                      color: r == 8
                                          ? const Color(0xFF20304A)
                                          : const Color(0xFFB9C4D5),
                                      width: r == 8 ? 0 : 0,
                                    ),
                                  ),
                                ),
                                child: Center(
                                  child: cell.value != 0
                                      ? Text(
                                          '${cell.value}',
                                          style: TextStyle(
                                            fontSize: cellFont,
                                            fontWeight: cell.given
                                                ? FontWeight.w900
                                                : FontWeight.w700,
                                            color: cell.given
                                                ? const Color(0xFF111827)
                                                : const Color(0xFF2563EB),
                                          ),
                                        )
                                      : Padding(
                                          padding: const EdgeInsets.all(3),
                                          child: GridView.count(
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            crossAxisCount: 3,
                                            children: List.generate(9, (index) {
                                              final note = index + 1;
                                              return Center(
                                                child: Text(
                                                  cell.notes.contains(note)
                                                      ? '$note'
                                                      : '',
                                                  style: TextStyle(
                                                    fontSize: noteFont,
                                                    fontWeight: FontWeight.w700,
                                                    color: const Color(
                                                      0xFF93A1B5,
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }),
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
              ),
            ),
          ),
        );
      },
    );
  }
}
