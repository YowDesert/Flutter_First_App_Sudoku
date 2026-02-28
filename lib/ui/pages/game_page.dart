import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

import '../../models/game_state.dart';
import '../widgets/board_widget.dart';
import '../widgets/number_pad.dart';
import 'result_page.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  String lastDisplayedMessage = '';
  bool _isNavigatingToResult = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<GameState>(
      builder: (_, state, __) {
        if (state.lastMessage.isNotEmpty &&
            state.lastMessage != lastDisplayedMessage) {
          lastDisplayedMessage = state.lastMessage;
          final messenger = ScaffoldMessenger.of(context);
          SchedulerBinding.instance.addPostFrameCallback((_) {
            if (!mounted) return;
            messenger.showSnackBar(
              SnackBar(
                content: Text(state.lastMessage),
                duration: const Duration(seconds: 2),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            );
          });
        }

        if (!_isNavigatingToResult &&
            ((state.puzzle?.isComplete ?? false) || state.health <= 0)) {
          _isNavigatingToResult = true;
          SchedulerBinding.instance.addPostFrameCallback((_) {
            if (!mounted) return;
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const ResultPage()),
            );
          });
        }

        final theme = Theme.of(context);
        final colorScheme = theme.colorScheme;

        return Scaffold(
          appBar: AppBar(
            backgroundColor: const Color(0xFFF7F9FD),
            foregroundColor: const Color(0xFF1F2937),
            surfaceTintColor: Colors.transparent,
            title: Text('Sudoku ${state.difficulty.name.toUpperCase()}'),
            actions: [
              IconButton(
                tooltip: '返回首頁',
                onPressed: () =>
                    Navigator.popUntil(context, (route) => route.isFirst),
                icon: const Icon(Icons.home_rounded),
              ),
            ],
          ),
          body: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFFF5F7FB),
                  colorScheme.primary.withValues(alpha: 0.08),
                  const Color(0xFFE9EEF8),
                ],
              ),
            ),
            child: SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth >= 980;
                  final horizontalPadding = isWide ? 28.0 : 16.0;

                  if (isWide) {
                    return Padding(
                      padding: EdgeInsets.fromLTRB(
                        horizontalPadding,
                        20,
                        horizontalPadding,
                        20,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            flex: 7,
                            child: Column(
                              children: [
                                _StatusStrip(state: state, wide: true),
                                const SizedBox(height: 18),
                                const Expanded(child: _BoardPanel()),
                                const SizedBox(height: 14),
                                const NumberPad(compact: true),
                              ],
                            ),
                          ),
                          const SizedBox(width: 20),
                          SizedBox(
                            width: 340,
                            child: _ActionPanel(
                              state: state,
                              wide: true,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return Padding(
                    padding: EdgeInsets.fromLTRB(
                      horizontalPadding,
                      12,
                      horizontalPadding,
                      14,
                    ),
                    child: Column(
                      children: [
                        _StatusStrip(state: state, wide: false),
                        const SizedBox(height: 12),
                        const Expanded(
                          child: _BoardPanel(),
                        ),
                        const SizedBox(height: 12),
                        _ActionPanel(state: state, wide: false),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

class _BoardPanel extends StatelessWidget {
  const _BoardPanel();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.88),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.92),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withValues(alpha: 0.08),
            blurRadius: 30,
            offset: const Offset(0, 18),
          ),
          BoxShadow(
            color: Colors.white.withValues(alpha: 0.75),
            blurRadius: 18,
            offset: const Offset(-6, -6),
          ),
        ],
      ),
      child: const BoardWidget(),
    );
  }
}

class _StatusStrip extends StatelessWidget {
  final GameState state;
  final bool wide;

  const _StatusStrip({
    required this.state,
    required this.wide,
  });

  @override
  Widget build(BuildContext context) {
    final cards = [
      _TopMetric(
        icon: Icons.stars_rounded,
        label: '分數',
        value: '${state.score}',
        accent: const Color(0xFFFFB703),
      ),
      _TopMetric(
        icon: Icons.local_fire_department_rounded,
        label: '連擊',
        value: '${state.combo}',
        accent: const Color(0xFFFB5607),
      ),
      _TopMetric(
        icon: Icons.favorite_rounded,
        label: '體力',
        value: '${state.health}/${GameState.maxHealth}',
        accent: const Color(0xFFE63946),
        progress: state.health / GameState.maxHealth,
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = wide
            ? 190.0
            : ((constraints.maxWidth - 24) / 3).clamp(96.0, 160.0);

        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            for (final card in cards)
              SizedBox(
                width: cardWidth,
                child: card,
              ),
          ],
        );
      },
    );
  }
}

class _TopMetric extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color accent;
  final double? progress;

  const _TopMetric({
    required this.icon,
    required this.label,
    required this.value,
    required this.accent,
    this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.86),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: accent.withValues(alpha: 0.16)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: accent, size: 18),
              ),
              const Spacer(),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Colors.black.withValues(alpha: 0.55),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.2,
            ),
          ),
          if (progress != null) ...[
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 7,
                backgroundColor: accent.withValues(alpha: 0.08),
                valueColor: AlwaysStoppedAnimation<Color>(accent),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ActionPanel extends StatelessWidget {
  final GameState state;
  final bool wide;

  const _ActionPanel({
    required this.state,
    required this.wide,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(wide ? 20 : 16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.82),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.9),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 22,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '操作面板',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 6),
          Text(
            '選格後輸入數字，棋盤會維持主視覺；數字列固定放在棋盤下方。',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.black.withValues(alpha: 0.55),
                ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _QuickActionButton(
                icon: state.mode == Mode.normal
                    ? Icons.edit_rounded
                    : Icons.draw_rounded,
                title: state.mode == Mode.normal ? '填數模式' : '筆記模式',
                subtitle: state.mode == Mode.normal ? '直接填入答案' : '先記候選數',
                selected: state.mode == Mode.notes,
                onTap: state.toggleMode,
              ),
              _QuickActionButton(
                icon: state.showErrors
                    ? Icons.rule_folder_rounded
                    : Icons.visibility_off_rounded,
                title: state.showErrors ? '顯示錯誤' : '隱藏錯誤',
                subtitle: '切換即時檢查',
                selected: state.showErrors,
                onTap: state.toggleErrors,
              ),
              _QuickActionButton(
                icon: Icons.lightbulb_rounded,
                title: '提示 A',
                subtitle: '目前格提示',
                selected: false,
                onTap: state.hintA,
              ),
              _QuickActionButton(
                icon: Icons.auto_fix_high_rounded,
                title: '提示 B',
                subtitle: '自動找一格',
                selected: false,
                onTap: state.hintB,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFF4F7FB),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFFD7E2F1)),
            ),
            child: const Text(
              '提示每次消耗 5 體力與 5 分，錯誤會中斷連擊。',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          if (!wide) ...[
            const SizedBox(height: 18),
            const NumberPad(compact: true),
          ],
        ],
      ),
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  const _QuickActionButton({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final borderColor = selected
        ? colorScheme.primary.withValues(alpha: 0.35)
        : const Color(0xFFD8E0EC);
    final background = selected
        ? colorScheme.primary.withValues(alpha: 0.1)
        : const Color(0xFFF9FBFD);

    return SizedBox(
      width: 145,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Ink(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: background,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: borderColor, width: 1.2),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: selected
                        ? colorScheme.primary.withValues(alpha: 0.14)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    size: 18,
                    color: selected
                        ? colorScheme.primary
                        : Colors.black.withValues(alpha: 0.7),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.black.withValues(alpha: 0.55),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
