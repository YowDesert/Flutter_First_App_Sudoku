import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/game_controller.dart';
import '../../models/app_enums.dart';
import '../theme/game_theme.dart';

class ResultPage extends StatelessWidget {
  const ResultPage({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = GameTheme.ui(context);
    final result = context.read<GameController>().lastResult;
    if (result == null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: FilledButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Back'),
          ),
        ),
      );
    }

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              palette.gameBackgroundTop,
              palette.gameBackgroundMid,
              palette.gameBackgroundBottom,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(28),
                    gradient: palette.primaryButtonGradient,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        result.isDaily ? 'Daily Cleared' : 'Board Cleared',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          color: palette.buttonText,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        result.isDaily
                            ? 'Streak is now ${result.updatedStreak}.'
                            : 'Clean finish. Ready for another board.',
                        style: TextStyle(
                          color: palette.buttonText.withValues(alpha: 0.78),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                _StatRow(
                    label: 'Time',
                    value: _formatSeconds(result.elapsedSeconds)),
                _StatRow(label: 'Mistakes', value: '${result.mistakes}'),
                _StatRow(label: 'Hints', value: '${result.hintsUsed}'),
                _StatRow(label: 'Difficulty', value: result.difficulty.label),
                _StatRow(
                    label: 'Coins Earned', value: '+${result.coinsEarned}'),
                _StatRow(label: 'Total Coins', value: '${result.totalCoins}'),
                if (result.streakBonusCoins > 0)
                  _StatRow(
                    label: 'Streak Bonus',
                    value: '+${result.streakBonusCoins}',
                  ),
                if (result.isDaily)
                  _StatRow(
                    label: 'Challenge Date',
                    value: result.challengeDateKey ?? '-',
                  ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () => Navigator.of(context)
                        .popUntil((route) => route.isFirst),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: palette.dailyAccent,
                    ),
                    child: const Text('Back To Home'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static String _formatSeconds(int total) {
    final minutes = (total ~/ 60).toString().padLeft(2, '0');
    final seconds = (total % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}

class _StatRow extends StatelessWidget {
  const _StatRow({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final palette = GameTheme.ui(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: palette.panelStroke.withValues(alpha: 0.8)),
      ),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
              color: palette.textMuted.withValues(alpha: 0.9),
              fontWeight: FontWeight.w700,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: palette.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
