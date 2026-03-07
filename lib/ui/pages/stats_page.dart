import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/game_controller.dart';
import '../theme/game_theme.dart';

class StatsPage extends StatelessWidget {
  const StatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GameController>(
      builder: (context, controller, _) {
        final palette = GameTheme.ui(context);
        final stats = controller.playerStats;
        final totalDailyCompleted = controller.dailyProgress.completedDates.length;
        final completionRate = stats.totalGames == 0
            ? 0.0
            : (stats.perfectGames / stats.totalGames) * 100;

        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Stats',
              style: TextStyle(
                color: palette.textPrimary,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          body: Stack(
            children: [
              const Positioned.fill(child: _StatsBackground()),
              ListView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
                children: [
                  _SectionCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Overview', style: GameTheme.sectionTitle(context)),
                        const SizedBox(height: 12),
                        _KpiGrid(
                          items: [
                            _KpiData('Games', '${stats.totalGames}'),
                            _KpiData('Daily Clears', '${stats.dailyGames}'),
                            _KpiData('Quick Clears', '${stats.quickGames}'),
                            _KpiData('Perfect', '${stats.perfectGames}'),
                            _KpiData(
                                'Coins Earned', '+${stats.totalCoinsEarned}'),
                            _KpiData('Calendar Clears', '$totalDailyCompleted'),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  _SectionCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Averages', style: GameTheme.sectionTitle(context)),
                        const SizedBox(height: 12),
                        _StatLine(
                          label: 'Avg Time',
                          value: _formatDuration(
                            _safeAverage(
                              stats.totalElapsedSeconds,
                              stats.totalGames,
                            ),
                          ),
                        ),
                        _StatLine(
                          label: 'Avg Mistakes',
                          value: _formatAverage(
                            _safeAverage(stats.totalMistakes, stats.totalGames),
                          ),
                        ),
                        _StatLine(
                          label: 'Avg Hints',
                          value: _formatAverage(
                            _safeAverage(stats.totalHintsUsed, stats.totalGames),
                          ),
                        ),
                        _StatLine(
                          label: 'Perfect Rate',
                          value: '${completionRate.toStringAsFixed(1)}%',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  _SectionCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Best Time', style: GameTheme.sectionTitle(context)),
                        const SizedBox(height: 12),
                        _StatLine(
                          label: 'Daily',
                          value: _formatDuration(stats.bestDailySeconds),
                        ),
                        _StatLine(
                          label: 'Quick Easy',
                          value: _formatDuration(stats.bestQuickEasySeconds),
                        ),
                        _StatLine(
                          label: 'Quick Medium',
                          value: _formatDuration(stats.bestQuickMediumSeconds),
                        ),
                        _StatLine(
                          label: 'Last Played',
                          value: stats.lastPlayedDateKey ?? '--',
                        ),
                      ],
                    ),
                  ),
                  if (stats.totalGames == 0) ...[
                    const SizedBox(height: 12),
                    _SectionCard(
                      child: Text(
                        'No completed boards yet. Finish one game and stats will appear here.',
                        style: GameTheme.modeBody(context),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  static double _safeAverage(int total, int count) {
    if (count <= 0) return 0.0;
    return total / count;
  }

  static String _formatAverage(double value) {
    return value.toStringAsFixed(1);
  }

  static String _formatDuration(num? totalSeconds) {
    if (totalSeconds == null) return '--';
    final rounded = totalSeconds.round();
    final minutes = (rounded ~/ 60).toString().padLeft(2, '0');
    final seconds = (rounded % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}

class _KpiData {
  const _KpiData(this.label, this.value);

  final String label;
  final String value;
}

class _KpiGrid extends StatelessWidget {
  const _KpiGrid({
    required this.items,
  });

  final List<_KpiData> items;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: items
          .map(
            (item) => SizedBox(
              width: 150,
              child: _KpiTile(
                label: item.label,
                value: item.value,
              ),
            ),
          )
          .toList(),
    );
  }
}

class _KpiTile extends StatelessWidget {
  const _KpiTile({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final palette = GameTheme.ui(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.74),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: palette.panelStroke),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GameTheme.chipText(context).copyWith(
              color: palette.textMuted,
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: palette.textPrimary,
                  fontWeight: FontWeight.w900,
                ),
          ),
        ],
      ),
    );
  }
}

class _StatLine extends StatelessWidget {
  const _StatLine({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final palette = GameTheme.ui(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Text(
            label,
            style: GameTheme.chipText(context).copyWith(
              color: palette.textMuted,
              fontSize: 12,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: palette.textPrimary,
                  fontWeight: FontWeight.w800,
                ),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final palette = GameTheme.ui(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withValues(alpha: 0.92),
                Colors.white.withValues(alpha: 0.76),
              ],
            ),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: palette.panelStroke),
            boxShadow: palette.panelShadow,
          ),
          child: child,
        ),
      ),
    );
  }
}

class _StatsBackground extends StatelessWidget {
  const _StatsBackground();

  @override
  Widget build(BuildContext context) {
    final palette = GameTheme.ui(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            palette.homeBackgroundTop,
            palette.homeBackgroundMid,
            palette.homeBackgroundBottom,
          ],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -78,
            left: -62,
            child: _BackdropOrb(
              size: 260,
              color: palette.dailyAccent.withValues(alpha: 0.25),
            ),
          ),
          Positioned(
            right: -72,
            top: 120,
            child: _BackdropOrb(
              size: 230,
              color: palette.quickAccent.withValues(alpha: 0.22),
            ),
          ),
          Positioned(
            left: 24,
            bottom: -104,
            child: _BackdropOrb(
              size: 250,
              color: palette.successAccent.withValues(alpha: 0.2),
            ),
          ),
        ],
      ),
    );
  }
}

class _BackdropOrb extends StatelessWidget {
  const _BackdropOrb({
    required this.size,
    required this.color,
  });

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              color,
              color.withValues(alpha: 0),
            ],
          ),
        ),
      ),
    );
  }
}
