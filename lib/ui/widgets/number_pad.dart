import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/game_state.dart';

class NumberPad extends StatelessWidget {
  final bool compact;

  const NumberPad({
    super.key,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final state = context.read<GameState>();

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : MediaQuery.sizeOf(context).width;
        final crossAxisCount = compact ? 10 : 3;
        final gap = compact ? 8.0 : 12.0;
        final rawTileSize =
            (width - (crossAxisCount - 1) * gap) / crossAxisCount;
        final tileSize = compact
            ? rawTileSize.clamp(32.0, 46.0)
            : math.max(54.0, rawTileSize);

        return Wrap(
          alignment: WrapAlignment.center,
          spacing: gap,
          runSpacing: gap,
          children: [
            for (int value = 1; value <= 9; value++)
              _PadButton(
                label: '$value',
                size: tileSize,
                onPressed: () => state.input(value),
              ),
            _PadButton(
              label: 'X',
              size: tileSize,
              destructive: true,
              icon: Icons.backspace_rounded,
              onPressed: state.erase,
            ),
          ],
        );
      },
    );
  }
}

class _PadButton extends StatelessWidget {
  final String label;
  final double size;
  final bool destructive;
  final IconData? icon;
  final VoidCallback onPressed;

  const _PadButton({
    required this.label,
    required this.size,
    required this.onPressed,
    this.destructive = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final color =
        destructive ? const Color(0xFFE76F51) : const Color(0xFF1D4ED8);
    final background =
        destructive ? const Color(0xFFFFF1ED) : const Color(0xFFF3F7FF);
    final radius = size <= 40 ? 12.0 : 18.0;

    return SizedBox(
      width: size,
      height: size,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(radius),
          child: Ink(
            decoration: BoxDecoration(
              color: background,
              borderRadius: BorderRadius.circular(radius),
              border: Border.all(color: color.withValues(alpha: 0.22)),
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.08),
                  blurRadius: 10,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Center(
              child: icon == null
                  ? Text(
                      label,
                      style: TextStyle(
                        fontSize: size * 0.34,
                        fontWeight: FontWeight.w800,
                        color: color,
                      ),
                    )
                  : Icon(icon, color: color, size: size * 0.34),
            ),
          ),
        ),
      ),
    );
  }
}
