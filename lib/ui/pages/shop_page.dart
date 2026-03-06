import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/game_controller.dart';
import '../../models/skin_catalog.dart';
import '../theme/game_theme.dart';

enum _ShopItemState {
  locked,
  owned,
  equipped,
}

class ShopPage extends StatelessWidget {
  const ShopPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GameController>(
      builder: (context, controller, _) {
        final palette = GameTheme.ui(context);

        return DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              title: Text(
                'Shop',
                style: TextStyle(
                  color: palette.textPrimary,
                  fontWeight: FontWeight.w900,
                ),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 14),
                  child: _CoinsPill(coins: controller.coins),
                ),
              ],
              bottom: TabBar(
                labelColor: palette.textPrimary,
                unselectedLabelColor: palette.textMuted,
                indicatorColor: palette.quickAccent,
                tabs: const [
                  Tab(text: 'Themes'),
                  Tab(text: 'Board Skins'),
                ],
              ),
            ),
            body: Stack(
              children: [
                const Positioned.fill(child: _ShopBackground()),
                TabBarView(
                  children: [
                    _ThemeShopList(
                      items: controller.themeCatalog,
                      onTap: (item) {
                        final result = controller.purchaseOrEquipTheme(item.id);
                        _showResultSnackBar(context, result);
                      },
                    ),
                    _BoardSkinShopList(
                      items: controller.boardSkinCatalog,
                      onTap: (item) {
                        final result =
                            controller.purchaseOrEquipBoardSkin(item.id);
                        _showResultSnackBar(context, result);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showResultSnackBar(BuildContext context, ShopActionResult result) {
    final palette = GameTheme.ui(context);
    final error = result.status == ShopActionStatus.insufficientCoins ||
        result.status == ShopActionStatus.notFound;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(result.message),
          backgroundColor: error ? palette.dangerAccent : palette.quickAccent,
          duration: const Duration(milliseconds: 1400),
        ),
      );
  }
}

class _CoinsPill extends StatelessWidget {
  const _CoinsPill({
    required this.coins,
  });

  final int coins;

  @override
  Widget build(BuildContext context) {
    final palette = GameTheme.ui(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.76),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: palette.panelStroke),
      ),
      child: Row(
        children: [
          Icon(Icons.monetization_on_rounded, color: palette.quickAccent),
          const SizedBox(width: 5),
          Text(
            '$coins',
            style: GameTheme.chipText(context).copyWith(
              color: palette.textPrimary,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _ThemeShopList extends StatelessWidget {
  const _ThemeShopList({
    required this.items,
    required this.onTap,
  });

  final List<ThemeSkinDefinition> items;
  final ValueChanged<ThemeSkinDefinition> onTap;

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<GameController>();
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 26),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final item = items[index];
        final state = _resolveState(
          owned: controller.ownsTheme(item.id),
          equipped: controller.isThemeEquipped(item.id),
        );
        return _ShopItemCard(
          title: item.name,
          price: item.price,
          state: state,
          preview: _ThemePreview(item: item),
          onAction: () => onTap(item),
        );
      },
    );
  }
}

class _BoardSkinShopList extends StatelessWidget {
  const _BoardSkinShopList({
    required this.items,
    required this.onTap,
  });

  final List<BoardSkinDefinition> items;
  final ValueChanged<BoardSkinDefinition> onTap;

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<GameController>();
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 26),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final item = items[index];
        final state = _resolveState(
          owned: controller.ownsBoardSkin(item.id),
          equipped: controller.isBoardSkinEquipped(item.id),
        );
        return _ShopItemCard(
          title: item.name,
          price: item.price,
          state: state,
          preview: _BoardPreview(item: item),
          onAction: () => onTap(item),
        );
      },
    );
  }
}

class _ShopItemCard extends StatelessWidget {
  const _ShopItemCard({
    required this.title,
    required this.price,
    required this.state,
    required this.preview,
    required this.onAction,
  });

  final String title;
  final int price;
  final _ShopItemState state;
  final Widget preview;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    final palette = GameTheme.ui(context);
    final statusColor = _statusColor(state, palette);
    final actionEnabled = state != _ShopItemState.equipped;
    final actionLabel = _actionLabel(state, price);

    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 7, sigmaY: 7),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withValues(alpha: 0.92),
                Colors.white.withValues(alpha: 0.74),
              ],
            ),
            border: Border.all(color: palette.panelStroke),
            borderRadius: BorderRadius.circular(22),
            boxShadow: palette.panelShadow,
          ),
          child: Row(
            children: [
              SizedBox(width: 88, height: 88, child: preview),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: palette.textPrimary,
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(
                          Icons.monetization_on_rounded,
                          size: 16,
                          color: palette.quickAccent,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '$price',
                          style: GameTheme.chipText(context).copyWith(
                            color: palette.textMuted,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.16),
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(
                          color: statusColor.withValues(alpha: 0.55),
                        ),
                      ),
                      child: Text(
                        _statusLabel(state),
                        style: GameTheme.chipText(context).copyWith(
                          color: statusColor,
                          fontWeight: FontWeight.w800,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              FilledButton(
                onPressed: actionEnabled ? onAction : null,
                style: FilledButton.styleFrom(
                  backgroundColor: actionEnabled
                      ? palette.quickAccent
                      : palette.textSubtle.withValues(alpha: 0.35),
                  foregroundColor: palette.buttonText,
                ),
                child: Text(actionLabel),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ThemePreview extends StatelessWidget {
  const _ThemePreview({
    required this.item,
  });

  final ThemeSkinDefinition item;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: item.previewColors,
        ),
        border: Border.all(color: Colors.white.withValues(alpha: 0.8)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Align(
          alignment: Alignment.bottomLeft,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _ColorDot(color: item.dailyAccent),
              const SizedBox(width: 4),
              _ColorDot(color: item.quickAccent),
              const SizedBox(width: 4),
              _ColorDot(color: item.successAccent),
            ],
          ),
        ),
      ),
    );
  }
}

class _BoardPreview extends StatelessWidget {
  const _BoardPreview({
    required this.item,
  });

  final BoardSkinDefinition item;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [item.panelGradientTop, item.panelGradientBottom],
        ),
        border: Border.all(color: item.panelBorder),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: List.generate(3, (row) {
            return Expanded(
              child: Row(
                children: List.generate(3, (col) {
                  final isSelected = row == 1 && col == 1;
                  return Expanded(
                    child: Container(
                      margin: const EdgeInsets.all(1),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? item.selectedCell
                            : ((row + col).isEven
                                ? item.cellEven
                                : item.cellOdd),
                        borderRadius: BorderRadius.circular(2),
                        border: Border.all(
                          color: row == 1 ? item.gridThick : item.gridThin,
                          width: row == 1 || col == 1 ? 1.1 : 0.7,
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
    );
  }
}

class _ColorDot extends StatelessWidget {
  const _ColorDot({
    required this.color,
  });

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}

class _ShopBackground extends StatelessWidget {
  const _ShopBackground();

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
            top: -70,
            left: -42,
            child: _BackdropOrb(
              size: 250,
              color: palette.dailyAccent.withValues(alpha: 0.25),
            ),
          ),
          Positioned(
            right: -66,
            top: 100,
            child: _BackdropOrb(
              size: 220,
              color: palette.quickAccent.withValues(alpha: 0.22),
            ),
          ),
          Positioned(
            left: 30,
            bottom: -100,
            child: _BackdropOrb(
              size: 240,
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

_ShopItemState _resolveState({
  required bool owned,
  required bool equipped,
}) {
  if (equipped) return _ShopItemState.equipped;
  if (owned) return _ShopItemState.owned;
  return _ShopItemState.locked;
}

String _statusLabel(_ShopItemState state) {
  switch (state) {
    case _ShopItemState.locked:
      return 'Locked';
    case _ShopItemState.owned:
      return 'Owned';
    case _ShopItemState.equipped:
      return 'Equipped';
  }
}

String _actionLabel(_ShopItemState state, int price) {
  switch (state) {
    case _ShopItemState.locked:
      return 'Buy $price';
    case _ShopItemState.owned:
      return 'Equip';
    case _ShopItemState.equipped:
      return 'Equipped';
  }
}

Color _statusColor(_ShopItemState state, GameUiPalette palette) {
  switch (state) {
    case _ShopItemState.locked:
      return palette.textMuted;
    case _ShopItemState.owned:
      return palette.quickAccent;
    case _ShopItemState.equipped:
      return palette.successAccent;
  }
}
