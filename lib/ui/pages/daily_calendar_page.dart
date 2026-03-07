import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/game_controller.dart';
import '../theme/game_theme.dart';
import 'game_page.dart';

class DailyCalendarPage extends StatefulWidget {
  const DailyCalendarPage({super.key});

  @override
  State<DailyCalendarPage> createState() => _DailyCalendarPageState();
}

class _DailyCalendarPageState extends State<DailyCalendarPage> {
  late DateTime _focusedMonth;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _focusedMonth = DateTime(now.year, now.month, 1);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GameController>(
      builder: (context, controller, _) {
        final palette = GameTheme.ui(context);
        final completedDates = controller.dailyProgress.completedDates;
        final currentStreak = controller.dailyProgress.streak;
        final today = _normalizedDate(DateTime.now());
        final monthCount = _countMonthCompletion(completedDates, _focusedMonth);
        final totalCount = completedDates.length;

        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Daily Calendar',
              style: TextStyle(
                color: palette.textPrimary,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          body: Stack(
            children: [
              const Positioned.fill(child: _CalendarBackground()),
              ListView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                children: [
                  _GlassCard(
                    child: Row(
                      children: [
                        Expanded(
                          child: _SummaryPill(
                            label: 'Current Streak',
                            value: '$currentStreak',
                            icon: Icons.local_fire_department_rounded,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _SummaryPill(
                            label: 'This Month',
                            value: '$monthCount',
                            icon: Icons.calendar_month_rounded,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _SummaryPill(
                            label: 'Total Clears',
                            value: '$totalCount',
                            icon: Icons.check_circle_rounded,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  _GlassCard(
                    child: Column(
                      children: [
                        _MonthHeader(
                          month: _focusedMonth,
                          onPrevious: () {
                            setState(() {
                              _focusedMonth = DateTime(
                                _focusedMonth.year,
                                _focusedMonth.month - 1,
                                1,
                              );
                            });
                          },
                          onNext: () {
                            setState(() {
                              _focusedMonth = DateTime(
                                _focusedMonth.year,
                                _focusedMonth.month + 1,
                                1,
                              );
                            });
                          },
                        ),
                        const SizedBox(height: 10),
                        const _WeekdayHeader(),
                        const SizedBox(height: 8),
                        _MonthGrid(
                          month: _focusedMonth,
                          today: today,
                          completedDates: completedDates,
                        ),
                        const SizedBox(height: 10),
                        const _LegendRow(),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  _GlassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Today', style: GameTheme.sectionTitle(context)),
                        const SizedBox(height: 6),
                        Text(
                          'Complete today\'s board to keep your streak growing.',
                          style: GameTheme.modeBody(context),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton.icon(
                            onPressed: () => _startTodayDaily(context),
                            icon: const Icon(Icons.play_arrow_rounded),
                            label: const Text('Play Today\'s Daily'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _startTodayDaily(BuildContext context) {
    final controller = context.read<GameController>();
    final active = controller.session;
    if (active != null && active.isDaily) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const GamePage()),
      );
      return;
    }
    controller.startDailyChallenge();
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const GamePage()),
    );
  }

  int _countMonthCompletion(Set<String> completedDates, DateTime month) {
    final prefix = '${month.year.toString().padLeft(4, '0')}-'
        '${month.month.toString().padLeft(2, '0')}-';
    return completedDates.where((dateKey) => dateKey.startsWith(prefix)).length;
  }

  DateTime _normalizedDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }
}

class _MonthHeader extends StatelessWidget {
  const _MonthHeader({
    required this.month,
    required this.onPrevious,
    required this.onNext,
  });

  final DateTime month;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final palette = GameTheme.ui(context);
    return Row(
      children: [
        _CircleButton(
          icon: Icons.chevron_left_rounded,
          onTap: onPrevious,
        ),
        const Spacer(),
        Text(
          _monthLabel(month),
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: palette.textPrimary,
                fontWeight: FontWeight.w900,
              ),
        ),
        const Spacer(),
        _CircleButton(
          icon: Icons.chevron_right_rounded,
          onTap: onNext,
        ),
      ],
    );
  }

  static String _monthLabel(DateTime month) {
    const names = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${names[month.month - 1]} ${month.year}';
  }
}

class _CircleButton extends StatelessWidget {
  const _CircleButton({
    required this.icon,
    required this.onTap,
  });

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = GameTheme.ui(context);
    return Material(
      color: Colors.transparent,
      child: Ink(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.75),
          shape: BoxShape.circle,
          border: Border.all(color: palette.panelStroke),
        ),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: Icon(icon, color: palette.textPrimary),
        ),
      ),
    );
  }
}

class _WeekdayHeader extends StatelessWidget {
  const _WeekdayHeader();

  @override
  Widget build(BuildContext context) {
    final palette = GameTheme.ui(context);
    const labels = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    return Row(
      children: labels
          .map(
            (label) => Expanded(
              child: Center(
                child: Text(
                  label,
                  style: GameTheme.chipText(context).copyWith(
                    color: palette.textMuted,
                    fontSize: 11,
                  ),
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

class _MonthGrid extends StatelessWidget {
  const _MonthGrid({
    required this.month,
    required this.today,
    required this.completedDates,
  });

  final DateTime month;
  final DateTime today;
  final Set<String> completedDates;

  @override
  Widget build(BuildContext context) {
    final slots = _buildSlots(month);
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: slots.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        crossAxisSpacing: 6,
        mainAxisSpacing: 6,
        childAspectRatio: 1.0,
      ),
      itemBuilder: (context, index) {
        final date = slots[index];
        if (date == null) {
          return const SizedBox.shrink();
        }
        final dateKey = _toDateKey(date);
        final isToday = _sameDay(date, today);
        final isCompleted = completedDates.contains(dateKey);
        final isFuture = date.isAfter(today);
        return _DayCell(
          day: date.day,
          isToday: isToday,
          isCompleted: isCompleted,
          isFuture: isFuture,
        );
      },
    );
  }

  List<DateTime?> _buildSlots(DateTime month) {
    final first = DateTime(month.year, month.month, 1);
    final days = DateUtils.getDaysInMonth(month.year, month.month);
    final leading = first.weekday % 7;

    final slots = List<DateTime?>.filled(leading, null, growable: true);
    for (var day = 1; day <= days; day++) {
      slots.add(DateTime(month.year, month.month, day));
    }
    while (slots.length % 7 != 0) {
      slots.add(null);
    }
    return slots;
  }

  String _toDateKey(DateTime date) {
    return '${date.year.toString().padLeft(4, '0')}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';
  }

  bool _sameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}

class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.day,
    required this.isToday,
    required this.isCompleted,
    required this.isFuture,
  });

  final int day;
  final bool isToday;
  final bool isCompleted;
  final bool isFuture;

  @override
  Widget build(BuildContext context) {
    final palette = GameTheme.ui(context);
    final bgColor = isCompleted
        ? palette.successAccent.withValues(alpha: 0.18)
        : Colors.white.withValues(alpha: isFuture ? 0.35 : 0.72);
    final borderColor = isToday
        ? palette.dailyAccent
        : (isCompleted
            ? palette.successAccent.withValues(alpha: 0.7)
            : palette.panelStroke);
    final textColor = isFuture
        ? palette.textSubtle
        : (isCompleted ? palette.successAccent : palette.textPrimary);

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: borderColor, width: isToday ? 1.7 : 1.0),
      ),
      child: Stack(
        children: [
          Center(
            child: Text(
              '$day',
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          if (isCompleted)
            Positioned(
              right: 3,
              bottom: 3,
              child: Icon(
                Icons.check_circle_rounded,
                size: 13,
                color: palette.successAccent,
              ),
            ),
        ],
      ),
    );
  }
}

class _LegendRow extends StatelessWidget {
  const _LegendRow();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 6,
      children: const [
        _LegendPill(
          color: Color(0xFF31C48D),
          label: 'Completed',
        ),
        _LegendPill(
          color: Color(0xFF16B9A4),
          label: 'Today',
        ),
        _LegendPill(
          color: Color(0xFF94A3B8),
          label: 'Future',
        ),
      ],
    );
  }
}

class _LegendPill extends StatelessWidget {
  const _LegendPill({
    required this.color,
    required this.label,
  });

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    final palette = GameTheme.ui(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.65),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: palette.panelStroke),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 9,
            height: 9,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: GameTheme.chipText(context),
          ),
        ],
      ),
    );
  }
}

class _SummaryPill extends StatelessWidget {
  const _SummaryPill({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final palette = GameTheme.ui(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 11),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: palette.quickAccent),
              const SizedBox(width: 5),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GameTheme.chipText(context).copyWith(
                    fontSize: 10,
                    color: palette.textMuted,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
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

class _GlassCard extends StatelessWidget {
  const _GlassCard({
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
                Colors.white.withValues(alpha: 0.9),
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

class _CalendarBackground extends StatelessWidget {
  const _CalendarBackground();

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
            top: -82,
            left: -56,
            child: _BackdropOrb(
              size: 268,
              color: palette.dailyAccent.withValues(alpha: 0.25),
            ),
          ),
          Positioned(
            right: -70,
            top: 112,
            child: _BackdropOrb(
              size: 235,
              color: palette.quickAccent.withValues(alpha: 0.2),
            ),
          ),
          Positioned(
            left: 26,
            bottom: -110,
            child: _BackdropOrb(
              size: 250,
              color: palette.successAccent.withValues(alpha: 0.18),
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
