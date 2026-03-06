import 'package:flutter/material.dart';

import '../../models/skin_catalog.dart';

@immutable
class GameUiPalette extends ThemeExtension<GameUiPalette> {
  const GameUiPalette({
    required this.homeBackgroundTop,
    required this.homeBackgroundMid,
    required this.homeBackgroundBottom,
    required this.gameBackgroundTop,
    required this.gameBackgroundMid,
    required this.gameBackgroundBottom,
    required this.dailyAccent,
    required this.quickAccent,
    required this.successAccent,
    required this.dangerAccent,
    required this.textPrimary,
    required this.textMuted,
    required this.textSubtle,
    required this.panelStroke,
    required this.primaryButtonGradient,
    required this.secondaryButtonGradient,
    required this.panelShadow,
    required this.buttonShadow,
    required this.buttonText,
    required this.keypadAccent,
    required this.utilityAccent,
    required this.hintAccent,
    required this.checkAccent,
  });

  final Color homeBackgroundTop;
  final Color homeBackgroundMid;
  final Color homeBackgroundBottom;

  final Color gameBackgroundTop;
  final Color gameBackgroundMid;
  final Color gameBackgroundBottom;

  final Color dailyAccent;
  final Color quickAccent;
  final Color successAccent;
  final Color dangerAccent;

  final Color textPrimary;
  final Color textMuted;
  final Color textSubtle;
  final Color panelStroke;

  final Gradient primaryButtonGradient;
  final Gradient secondaryButtonGradient;
  final List<BoxShadow> panelShadow;
  final List<BoxShadow> buttonShadow;
  final Color buttonText;

  final Color keypadAccent;
  final Color utilityAccent;
  final Color hintAccent;
  final Color checkAccent;

  @override
  GameUiPalette copyWith({
    Color? homeBackgroundTop,
    Color? homeBackgroundMid,
    Color? homeBackgroundBottom,
    Color? gameBackgroundTop,
    Color? gameBackgroundMid,
    Color? gameBackgroundBottom,
    Color? dailyAccent,
    Color? quickAccent,
    Color? successAccent,
    Color? dangerAccent,
    Color? textPrimary,
    Color? textMuted,
    Color? textSubtle,
    Color? panelStroke,
    Gradient? primaryButtonGradient,
    Gradient? secondaryButtonGradient,
    List<BoxShadow>? panelShadow,
    List<BoxShadow>? buttonShadow,
    Color? buttonText,
    Color? keypadAccent,
    Color? utilityAccent,
    Color? hintAccent,
    Color? checkAccent,
  }) {
    return GameUiPalette(
      homeBackgroundTop: homeBackgroundTop ?? this.homeBackgroundTop,
      homeBackgroundMid: homeBackgroundMid ?? this.homeBackgroundMid,
      homeBackgroundBottom: homeBackgroundBottom ?? this.homeBackgroundBottom,
      gameBackgroundTop: gameBackgroundTop ?? this.gameBackgroundTop,
      gameBackgroundMid: gameBackgroundMid ?? this.gameBackgroundMid,
      gameBackgroundBottom: gameBackgroundBottom ?? this.gameBackgroundBottom,
      dailyAccent: dailyAccent ?? this.dailyAccent,
      quickAccent: quickAccent ?? this.quickAccent,
      successAccent: successAccent ?? this.successAccent,
      dangerAccent: dangerAccent ?? this.dangerAccent,
      textPrimary: textPrimary ?? this.textPrimary,
      textMuted: textMuted ?? this.textMuted,
      textSubtle: textSubtle ?? this.textSubtle,
      panelStroke: panelStroke ?? this.panelStroke,
      primaryButtonGradient:
          primaryButtonGradient ?? this.primaryButtonGradient,
      secondaryButtonGradient:
          secondaryButtonGradient ?? this.secondaryButtonGradient,
      panelShadow: panelShadow ?? this.panelShadow,
      buttonShadow: buttonShadow ?? this.buttonShadow,
      buttonText: buttonText ?? this.buttonText,
      keypadAccent: keypadAccent ?? this.keypadAccent,
      utilityAccent: utilityAccent ?? this.utilityAccent,
      hintAccent: hintAccent ?? this.hintAccent,
      checkAccent: checkAccent ?? this.checkAccent,
    );
  }

  @override
  GameUiPalette lerp(
    covariant ThemeExtension<GameUiPalette>? other,
    double t,
  ) {
    if (other is! GameUiPalette) {
      return this;
    }
    return GameUiPalette(
      homeBackgroundTop:
          Color.lerp(homeBackgroundTop, other.homeBackgroundTop, t) ??
              homeBackgroundTop,
      homeBackgroundMid:
          Color.lerp(homeBackgroundMid, other.homeBackgroundMid, t) ??
              homeBackgroundMid,
      homeBackgroundBottom:
          Color.lerp(homeBackgroundBottom, other.homeBackgroundBottom, t) ??
              homeBackgroundBottom,
      gameBackgroundTop:
          Color.lerp(gameBackgroundTop, other.gameBackgroundTop, t) ??
              gameBackgroundTop,
      gameBackgroundMid:
          Color.lerp(gameBackgroundMid, other.gameBackgroundMid, t) ??
              gameBackgroundMid,
      gameBackgroundBottom:
          Color.lerp(gameBackgroundBottom, other.gameBackgroundBottom, t) ??
              gameBackgroundBottom,
      dailyAccent: Color.lerp(dailyAccent, other.dailyAccent, t) ?? dailyAccent,
      quickAccent: Color.lerp(quickAccent, other.quickAccent, t) ?? quickAccent,
      successAccent:
          Color.lerp(successAccent, other.successAccent, t) ?? successAccent,
      dangerAccent:
          Color.lerp(dangerAccent, other.dangerAccent, t) ?? dangerAccent,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t) ?? textPrimary,
      textMuted: Color.lerp(textMuted, other.textMuted, t) ?? textMuted,
      textSubtle: Color.lerp(textSubtle, other.textSubtle, t) ?? textSubtle,
      panelStroke: Color.lerp(panelStroke, other.panelStroke, t) ?? panelStroke,
      primaryButtonGradient:
          t < 0.5 ? primaryButtonGradient : other.primaryButtonGradient,
      secondaryButtonGradient:
          t < 0.5 ? secondaryButtonGradient : other.secondaryButtonGradient,
      panelShadow: t < 0.5 ? panelShadow : other.panelShadow,
      buttonShadow: t < 0.5 ? buttonShadow : other.buttonShadow,
      buttonText: Color.lerp(buttonText, other.buttonText, t) ?? buttonText,
      keypadAccent:
          Color.lerp(keypadAccent, other.keypadAccent, t) ?? keypadAccent,
      utilityAccent:
          Color.lerp(utilityAccent, other.utilityAccent, t) ?? utilityAccent,
      hintAccent: Color.lerp(hintAccent, other.hintAccent, t) ?? hintAccent,
      checkAccent: Color.lerp(checkAccent, other.checkAccent, t) ?? checkAccent,
    );
  }

  static GameUiPalette fromTheme(ThemeSkinDefinition skin) {
    return GameUiPalette(
      homeBackgroundTop: skin.homeBackgroundTop,
      homeBackgroundMid: skin.homeBackgroundMid,
      homeBackgroundBottom: skin.homeBackgroundBottom,
      gameBackgroundTop: skin.gameBackgroundTop,
      gameBackgroundMid: skin.gameBackgroundMid,
      gameBackgroundBottom: skin.gameBackgroundBottom,
      dailyAccent: skin.dailyAccent,
      quickAccent: skin.quickAccent,
      successAccent: skin.successAccent,
      dangerAccent: skin.dangerAccent,
      textPrimary: skin.textPrimary,
      textMuted: skin.textMuted,
      textSubtle: skin.textSubtle,
      panelStroke: skin.panelStroke,
      primaryButtonGradient: skin.primaryButtonGradient,
      secondaryButtonGradient: skin.secondaryButtonGradient,
      panelShadow: skin.panelShadow,
      buttonShadow: skin.buttonShadow,
      buttonText: skin.buttonText,
      keypadAccent: skin.keypadAccent,
      utilityAccent: skin.utilityAccent,
      hintAccent: skin.hintAccent,
      checkAccent: skin.checkAccent,
    );
  }
}

@immutable
class BoardPalette extends ThemeExtension<BoardPalette> {
  const BoardPalette({
    required this.panelGradientTop,
    required this.panelGradientBottom,
    required this.panelBorder,
    required this.panelShadow,
    required this.cellEven,
    required this.cellOdd,
    required this.sameRowColOverlay,
    required this.sameBoxOverlay,
    required this.sameValueOverlay,
    required this.selectedCell,
    required this.errorOverlay,
    required this.selectedBorder,
    required this.gridThin,
    required this.gridThick,
    required this.givenDigit,
    required this.userDigit,
    required this.errorDigit,
    required this.noteActive,
    required this.noteInactive,
    required this.tapSplash,
  });

  final Color panelGradientTop;
  final Color panelGradientBottom;
  final Color panelBorder;
  final Color panelShadow;

  final Color cellEven;
  final Color cellOdd;
  final Color sameRowColOverlay;
  final Color sameBoxOverlay;
  final Color sameValueOverlay;
  final Color selectedCell;
  final Color errorOverlay;
  final Color selectedBorder;

  final Color gridThin;
  final Color gridThick;

  final Color givenDigit;
  final Color userDigit;
  final Color errorDigit;
  final Color noteActive;
  final Color noteInactive;
  final Color tapSplash;

  @override
  BoardPalette copyWith({
    Color? panelGradientTop,
    Color? panelGradientBottom,
    Color? panelBorder,
    Color? panelShadow,
    Color? cellEven,
    Color? cellOdd,
    Color? sameRowColOverlay,
    Color? sameBoxOverlay,
    Color? sameValueOverlay,
    Color? selectedCell,
    Color? errorOverlay,
    Color? selectedBorder,
    Color? gridThin,
    Color? gridThick,
    Color? givenDigit,
    Color? userDigit,
    Color? errorDigit,
    Color? noteActive,
    Color? noteInactive,
    Color? tapSplash,
  }) {
    return BoardPalette(
      panelGradientTop: panelGradientTop ?? this.panelGradientTop,
      panelGradientBottom: panelGradientBottom ?? this.panelGradientBottom,
      panelBorder: panelBorder ?? this.panelBorder,
      panelShadow: panelShadow ?? this.panelShadow,
      cellEven: cellEven ?? this.cellEven,
      cellOdd: cellOdd ?? this.cellOdd,
      sameRowColOverlay: sameRowColOverlay ?? this.sameRowColOverlay,
      sameBoxOverlay: sameBoxOverlay ?? this.sameBoxOverlay,
      sameValueOverlay: sameValueOverlay ?? this.sameValueOverlay,
      selectedCell: selectedCell ?? this.selectedCell,
      errorOverlay: errorOverlay ?? this.errorOverlay,
      selectedBorder: selectedBorder ?? this.selectedBorder,
      gridThin: gridThin ?? this.gridThin,
      gridThick: gridThick ?? this.gridThick,
      givenDigit: givenDigit ?? this.givenDigit,
      userDigit: userDigit ?? this.userDigit,
      errorDigit: errorDigit ?? this.errorDigit,
      noteActive: noteActive ?? this.noteActive,
      noteInactive: noteInactive ?? this.noteInactive,
      tapSplash: tapSplash ?? this.tapSplash,
    );
  }

  @override
  BoardPalette lerp(
    covariant ThemeExtension<BoardPalette>? other,
    double t,
  ) {
    if (other is! BoardPalette) {
      return this;
    }

    Color lerp(Color from, Color to) => Color.lerp(from, to, t) ?? from;

    return BoardPalette(
      panelGradientTop: lerp(panelGradientTop, other.panelGradientTop),
      panelGradientBottom: lerp(panelGradientBottom, other.panelGradientBottom),
      panelBorder: lerp(panelBorder, other.panelBorder),
      panelShadow: lerp(panelShadow, other.panelShadow),
      cellEven: lerp(cellEven, other.cellEven),
      cellOdd: lerp(cellOdd, other.cellOdd),
      sameRowColOverlay: lerp(sameRowColOverlay, other.sameRowColOverlay),
      sameBoxOverlay: lerp(sameBoxOverlay, other.sameBoxOverlay),
      sameValueOverlay: lerp(sameValueOverlay, other.sameValueOverlay),
      selectedCell: lerp(selectedCell, other.selectedCell),
      errorOverlay: lerp(errorOverlay, other.errorOverlay),
      selectedBorder: lerp(selectedBorder, other.selectedBorder),
      gridThin: lerp(gridThin, other.gridThin),
      gridThick: lerp(gridThick, other.gridThick),
      givenDigit: lerp(givenDigit, other.givenDigit),
      userDigit: lerp(userDigit, other.userDigit),
      errorDigit: lerp(errorDigit, other.errorDigit),
      noteActive: lerp(noteActive, other.noteActive),
      noteInactive: lerp(noteInactive, other.noteInactive),
      tapSplash: lerp(tapSplash, other.tapSplash),
    );
  }

  static BoardPalette fromBoardSkin(BoardSkinDefinition skin) {
    return BoardPalette(
      panelGradientTop: skin.panelGradientTop,
      panelGradientBottom: skin.panelGradientBottom,
      panelBorder: skin.panelBorder,
      panelShadow: skin.panelShadow,
      cellEven: skin.cellEven,
      cellOdd: skin.cellOdd,
      sameRowColOverlay: skin.sameRowColOverlay,
      sameBoxOverlay: skin.sameBoxOverlay,
      sameValueOverlay: skin.sameValueOverlay,
      selectedCell: skin.selectedCell,
      errorOverlay: skin.errorOverlay,
      selectedBorder: skin.selectedBorder,
      gridThin: skin.gridThin,
      gridThick: skin.gridThick,
      givenDigit: skin.givenDigit,
      userDigit: skin.userDigit,
      errorDigit: skin.errorDigit,
      noteActive: skin.noteActive,
      noteInactive: skin.noteInactive,
      tapSplash: skin.tapSplash,
    );
  }
}

class GameTheme {
  const GameTheme._();

  static ThemeData buildThemeData({
    required ThemeSkinDefinition themeSkin,
    required BoardSkinDefinition boardSkin,
  }) {
    final baseScheme = ColorScheme.fromSeed(
      seedColor: themeSkin.seedColor,
      brightness: Brightness.light,
    );

    final uiPalette = GameUiPalette.fromTheme(themeSkin);
    final boardPalette = BoardPalette.fromBoardSkin(boardSkin);

    return ThemeData(
      useMaterial3: true,
      colorScheme: baseScheme.copyWith(
        primary: themeSkin.seedColor,
        secondary: themeSkin.quickAccent,
        tertiary: themeSkin.successAccent,
        error: themeSkin.dangerAccent,
        surface: themeSkin.scaffoldBackground,
        surfaceContainer: themeSkin.cardBackground,
      ),
      scaffoldBackgroundColor: themeSkin.scaffoldBackground,
      cardTheme: CardThemeData(
        elevation: 0,
        color: themeSkin.cardBackground,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        margin: EdgeInsets.zero,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          textStyle: const TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          side: BorderSide(color: baseScheme.outlineVariant),
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        side: BorderSide(color: baseScheme.outlineVariant),
        labelStyle: const TextStyle(fontWeight: FontWeight.w700),
        backgroundColor: Colors.white,
        selectedColor: baseScheme.primaryContainer,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
      ),
      extensions: [uiPalette, boardPalette],
    );
  }

  static GameUiPalette ui(BuildContext context) =>
      Theme.of(context).extension<GameUiPalette>()!;

  static BoardPalette board(BuildContext context) =>
      Theme.of(context).extension<BoardPalette>()!;

  static TextStyle title(BuildContext context) {
    final palette = ui(context);
    return Theme.of(context).textTheme.headlineLarge!.copyWith(
          color: palette.textPrimary,
          fontWeight: FontWeight.w900,
          letterSpacing: -1.0,
          height: 1.0,
        );
  }

  static TextStyle slogan(BuildContext context) {
    final palette = ui(context);
    return Theme.of(context).textTheme.bodyLarge!.copyWith(
          color: palette.textMuted,
          fontWeight: FontWeight.w500,
          height: 1.35,
        );
  }

  static TextStyle sectionTitle(BuildContext context) {
    final palette = ui(context);
    return Theme.of(context).textTheme.titleLarge!.copyWith(
          color: palette.textPrimary,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.1,
        );
  }

  static TextStyle modeTitle(BuildContext context) {
    final palette = ui(context);
    return Theme.of(context).textTheme.titleMedium!.copyWith(
          color: palette.textPrimary,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.2,
        );
  }

  static TextStyle modeBody(BuildContext context) {
    final palette = ui(context);
    return Theme.of(context).textTheme.bodyMedium!.copyWith(
          color: palette.textMuted,
          height: 1.4,
          fontWeight: FontWeight.w500,
        );
  }

  static TextStyle chipText(BuildContext context) {
    final palette = ui(context);
    return Theme.of(context).textTheme.labelLarge!.copyWith(
          color: palette.textMuted,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.2,
        );
  }
}
