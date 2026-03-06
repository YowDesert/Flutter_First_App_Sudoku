import 'package:flutter/material.dart';

@immutable
class ThemeSkinDefinition {
  const ThemeSkinDefinition({
    required this.id,
    required this.name,
    required this.price,
    required this.seedColor,
    required this.scaffoldBackground,
    required this.cardBackground,
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
    required this.keypadAccent,
    required this.utilityAccent,
    required this.hintAccent,
    required this.checkAccent,
    this.panelShadow = const [
      BoxShadow(
        color: Color(0x1A2B5C74),
        blurRadius: 24,
        offset: Offset(0, 12),
      ),
    ],
    this.buttonShadow = const [
      BoxShadow(
        color: Color(0x3322A890),
        blurRadius: 14,
        offset: Offset(0, 8),
      ),
    ],
    this.buttonText = Colors.white,
  });

  final String id;
  final String name;
  final int price;

  final Color seedColor;
  final Color scaffoldBackground;
  final Color cardBackground;

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

  List<Color> get previewColors => [
        homeBackgroundTop,
        homeBackgroundMid,
        homeBackgroundBottom,
      ];
}

@immutable
class BoardSkinDefinition {
  const BoardSkinDefinition({
    required this.id,
    required this.name,
    required this.price,
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

  final String id;
  final String name;
  final int price;

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

  List<Color> get previewColors => [
        panelGradientTop,
        panelGradientBottom,
        selectedCell,
      ];
}

class SkinCatalog {
  const SkinCatalog._();

  static const String defaultThemeId = 'classic_light';
  static const String defaultBoardSkinId = 'crystal_grid';

  static const List<ThemeSkinDefinition> themes = [
    ThemeSkinDefinition(
      id: 'classic_light',
      name: 'Classic Light',
      price: 0,
      seedColor: Color(0xFF16B9A4),
      scaffoldBackground: Color(0xFFF3FBF8),
      cardBackground: Color(0xF0FFFFFF),
      homeBackgroundTop: Color(0xFFF2FFF9),
      homeBackgroundMid: Color(0xFFEAF7FF),
      homeBackgroundBottom: Color(0xFFFFF8ED),
      gameBackgroundTop: Color(0xFFF4F9FF),
      gameBackgroundMid: Color(0xFFF5FCF7),
      gameBackgroundBottom: Color(0xFFFFFBF2),
      dailyAccent: Color(0xFF16B9A4),
      quickAccent: Color(0xFF319DFF),
      successAccent: Color(0xFF31C48D),
      dangerAccent: Color(0xFFD55252),
      textPrimary: Color(0xFF14373C),
      textMuted: Color(0xFF4F6E74),
      textSubtle: Color(0xFF7E9BA2),
      panelStroke: Color(0x99FFFFFF),
      primaryButtonGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFF2FD6BF),
          Color(0xFF16B9A4),
        ],
      ),
      secondaryButtonGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFF67C0FF),
          Color(0xFF319DFF),
        ],
      ),
      keypadAccent: Color(0xFF3787ED),
      utilityAccent: Color(0xFFF6B98D),
      hintAccent: Color(0xFFC19538),
      checkAccent: Color(0xFF2B9D7E),
    ),
    ThemeSkinDefinition(
      id: 'mint_fresh',
      name: 'Mint Fresh',
      price: 280,
      seedColor: Color(0xFF1ABDA7),
      scaffoldBackground: Color(0xFFEFFCF8),
      cardBackground: Color(0xEBFFFFFF),
      homeBackgroundTop: Color(0xFFEFFDF8),
      homeBackgroundMid: Color(0xFFE6FFF7),
      homeBackgroundBottom: Color(0xFFF9FFF4),
      gameBackgroundTop: Color(0xFFF2FFF9),
      gameBackgroundMid: Color(0xFFEFFFF7),
      gameBackgroundBottom: Color(0xFFF9FFF9),
      dailyAccent: Color(0xFF1ABDA7),
      quickAccent: Color(0xFF3ABFCB),
      successAccent: Color(0xFF2DBE84),
      dangerAccent: Color(0xFFD95D60),
      textPrimary: Color(0xFF124A43),
      textMuted: Color(0xFF4D7A73),
      textSubtle: Color(0xFF7E9F99),
      panelStroke: Color(0x9AFFFFFF),
      primaryButtonGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFF3EE0C5),
          Color(0xFF1ABDA7),
        ],
      ),
      secondaryButtonGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFF69E3D7),
          Color(0xFF2CBFCB),
        ],
      ),
      keypadAccent: Color(0xFF29AFA0),
      utilityAccent: Color(0xFFF1BD83),
      hintAccent: Color(0xFFBE9A3A),
      checkAccent: Color(0xFF1F9A7E),
      buttonShadow: [
        BoxShadow(
          color: Color(0x2A1AA78D),
          blurRadius: 15,
          offset: Offset(0, 8),
        ),
      ],
    ),
    ThemeSkinDefinition(
      id: 'sky_blue',
      name: 'Sky Blue',
      price: 320,
      seedColor: Color(0xFF2D9EEA),
      scaffoldBackground: Color(0xFFF0F8FF),
      cardBackground: Color(0xEDFFFFFF),
      homeBackgroundTop: Color(0xFFEAF6FF),
      homeBackgroundMid: Color(0xFFEAFBFF),
      homeBackgroundBottom: Color(0xFFF5FCFF),
      gameBackgroundTop: Color(0xFFEFF6FF),
      gameBackgroundMid: Color(0xFFF2FAFF),
      gameBackgroundBottom: Color(0xFFF9FCFF),
      dailyAccent: Color(0xFF2495E6),
      quickAccent: Color(0xFF4A83F5),
      successAccent: Color(0xFF2CA78E),
      dangerAccent: Color(0xFFD05A62),
      textPrimary: Color(0xFF183E63),
      textMuted: Color(0xFF577997),
      textSubtle: Color(0xFF83A0BA),
      panelStroke: Color(0x98FFFFFF),
      primaryButtonGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFF59B6FF),
          Color(0xFF2D9EEA),
        ],
      ),
      secondaryButtonGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFF86BAFF),
          Color(0xFF4A83F5),
        ],
      ),
      keypadAccent: Color(0xFF2F7FE2),
      utilityAccent: Color(0xFFF7BA88),
      hintAccent: Color(0xFFC08D37),
      checkAccent: Color(0xFF2D94A2),
      buttonShadow: [
        BoxShadow(
          color: Color(0x2B2C80D9),
          blurRadius: 15,
          offset: Offset(0, 8),
        ),
      ],
    ),
    ThemeSkinDefinition(
      id: 'sunset_peach',
      name: 'Sunset Peach',
      price: 360,
      seedColor: Color(0xFFE68E72),
      scaffoldBackground: Color(0xFFFFF7F2),
      cardBackground: Color(0xEEFFFFFF),
      homeBackgroundTop: Color(0xFFFFF2E9),
      homeBackgroundMid: Color(0xFFFFF8F1),
      homeBackgroundBottom: Color(0xFFFFFCEE),
      gameBackgroundTop: Color(0xFFFFF4EA),
      gameBackgroundMid: Color(0xFFFFF8F0),
      gameBackgroundBottom: Color(0xFFFFFCF5),
      dailyAccent: Color(0xFFD77458),
      quickAccent: Color(0xFFEC9C56),
      successAccent: Color(0xFF48AE84),
      dangerAccent: Color(0xFFC8545C),
      textPrimary: Color(0xFF5E362F),
      textMuted: Color(0xFF896157),
      textSubtle: Color(0xFFB0887E),
      panelStroke: Color(0x9DFFFFFF),
      primaryButtonGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFFFFB082),
          Color(0xFFE68E72),
        ],
      ),
      secondaryButtonGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFFFFCF9B),
          Color(0xFFEC9C56),
        ],
      ),
      keypadAccent: Color(0xFFD87D5E),
      utilityAccent: Color(0xFFF0B782),
      hintAccent: Color(0xFFD0963A),
      checkAccent: Color(0xFF4AA486),
      buttonShadow: [
        BoxShadow(
          color: Color(0x2FE57F67),
          blurRadius: 15,
          offset: Offset(0, 8),
        ),
      ],
    ),
    ThemeSkinDefinition(
      id: 'lavender_soft',
      name: 'Lavender Soft',
      price: 390,
      seedColor: Color(0xFF8A88E8),
      scaffoldBackground: Color(0xFFF6F5FF),
      cardBackground: Color(0xECFFFFFF),
      homeBackgroundTop: Color(0xFFF2F0FF),
      homeBackgroundMid: Color(0xFFF7F6FF),
      homeBackgroundBottom: Color(0xFFFDFBFF),
      gameBackgroundTop: Color(0xFFF2F1FF),
      gameBackgroundMid: Color(0xFFF7F6FF),
      gameBackgroundBottom: Color(0xFFFDFBFF),
      dailyAccent: Color(0xFF7B79D8),
      quickAccent: Color(0xFF7E9DF5),
      successAccent: Color(0xFF4DAF8A),
      dangerAccent: Color(0xFFD05A77),
      textPrimary: Color(0xFF353865),
      textMuted: Color(0xFF646A9A),
      textSubtle: Color(0xFF9298BF),
      panelStroke: Color(0xA1FFFFFF),
      primaryButtonGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFFA9A5FF),
          Color(0xFF8A88E8),
        ],
      ),
      secondaryButtonGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFFBFD0FF),
          Color(0xFF7E9DF5),
        ],
      ),
      keypadAccent: Color(0xFF7E7CE0),
      utilityAccent: Color(0xFFF0BE8E),
      hintAccent: Color(0xFFB38E3A),
      checkAccent: Color(0xFF4C9D95),
      buttonShadow: [
        BoxShadow(
          color: Color(0x2E7D7DE0),
          blurRadius: 15,
          offset: Offset(0, 8),
        ),
      ],
    ),
  ];

  static const List<BoardSkinDefinition> boardSkins = [
    BoardSkinDefinition(
      id: 'crystal_grid',
      name: 'Crystal Grid',
      price: 0,
      panelGradientTop: Color(0xE6FFFFFF),
      panelGradientBottom: Color(0xB8FFFFFF),
      panelBorder: Color(0xCCFFFFFF),
      panelShadow: Color(0x2677A9D2),
      cellEven: Color(0xFFFDFEFF),
      cellOdd: Color(0xFFF7FAFF),
      sameRowColOverlay: Color(0x217FB9F7),
      sameBoxOverlay: Color(0x1C9BE4B8),
      sameValueOverlay: Color(0x33FFE08A),
      selectedCell: Color(0xFFD8EBFF),
      errorOverlay: Color(0x66FFBABA),
      selectedBorder: Color(0xFF2A8DED),
      gridThin: Color(0xFFCDDBEA),
      gridThick: Color(0xFF8EA3BF),
      givenDigit: Color(0xFF203B5D),
      userDigit: Color(0xFF2275E5),
      errorDigit: Color(0xFFD55252),
      noteActive: Color(0xFF6586AA),
      noteInactive: Color(0xFF7D91A8),
      tapSplash: Color(0x22368BE3),
    ),
    BoardSkinDefinition(
      id: 'mint_lattice',
      name: 'Mint Lattice',
      price: 210,
      panelGradientTop: Color(0xE8FFFFFF),
      panelGradientBottom: Color(0xC5EEFFF7),
      panelBorder: Color(0xCCE4FFF4),
      panelShadow: Color(0x2A56B89A),
      cellEven: Color(0xFFFAFFFc),
      cellOdd: Color(0xFFF3FBF8),
      sameRowColOverlay: Color(0x254CCCB0),
      sameBoxOverlay: Color(0x1A75EFD4),
      sameValueOverlay: Color(0x2EE7F29C),
      selectedCell: Color(0xFFCFF8EA),
      errorOverlay: Color(0x62FFB8BD),
      selectedBorder: Color(0xFF24AE8E),
      gridThin: Color(0xFFA4DCCF),
      gridThick: Color(0xFF5CAFA0),
      givenDigit: Color(0xFF1F4B4A),
      userDigit: Color(0xFF1F9A8D),
      errorDigit: Color(0xFFD95D60),
      noteActive: Color(0xFF4F8E85),
      noteInactive: Color(0xFF6A9F98),
      tapSplash: Color(0x2248BFA5),
    ),
    BoardSkinDefinition(
      id: 'sky_frame',
      name: 'Sky Frame',
      price: 240,
      panelGradientTop: Color(0xE7FFFFFF),
      panelGradientBottom: Color(0xC4EEF5FF),
      panelBorder: Color(0xCCE1ECFF),
      panelShadow: Color(0x2A5F83CA),
      cellEven: Color(0xFFFBFDFF),
      cellOdd: Color(0xFFF1F7FF),
      sameRowColOverlay: Color(0x255EACF8),
      sameBoxOverlay: Color(0x1A8EDCFF),
      sameValueOverlay: Color(0x2ED9E77B),
      selectedCell: Color(0xFFD6E9FF),
      errorOverlay: Color(0x61FFB3C2),
      selectedBorder: Color(0xFF3F88E8),
      gridThin: Color(0xFFBDD3F0),
      gridThick: Color(0xFF6D92C1),
      givenDigit: Color(0xFF243F66),
      userDigit: Color(0xFF2E7BDF),
      errorDigit: Color(0xFFD15C69),
      noteActive: Color(0xFF6288B2),
      noteInactive: Color(0xFF7D95B0),
      tapSplash: Color(0x224184E0),
    ),
    BoardSkinDefinition(
      id: 'peach_lines',
      name: 'Peach Lines',
      price: 260,
      panelGradientTop: Color(0xE9FFFFFF),
      panelGradientBottom: Color(0xC9FFF2EA),
      panelBorder: Color(0xCCFFE5D3),
      panelShadow: Color(0x2AAB7E6D),
      cellEven: Color(0xFFFFFEFD),
      cellOdd: Color(0xFFFFF8F3),
      sameRowColOverlay: Color(0x24FFA16C),
      sameBoxOverlay: Color(0x1AE9C17A),
      sameValueOverlay: Color(0x2EEECF85),
      selectedCell: Color(0xFFFFE3D2),
      errorOverlay: Color(0x65FFBAC2),
      selectedBorder: Color(0xFFDC875F),
      gridThin: Color(0xFFE3C6B2),
      gridThick: Color(0xFFC19071),
      givenDigit: Color(0xFF664338),
      userDigit: Color(0xFFD0744C),
      errorDigit: Color(0xFFC8545C),
      noteActive: Color(0xFF9A765E),
      noteInactive: Color(0xFFAB8B77),
      tapSplash: Color(0x22DB8B63),
    ),
  ];

  static ThemeSkinDefinition? tryThemeById(String id) {
    for (final theme in themes) {
      if (theme.id == id) {
        return theme;
      }
    }
    return null;
  }

  static BoardSkinDefinition? tryBoardSkinById(String id) {
    for (final boardSkin in boardSkins) {
      if (boardSkin.id == id) {
        return boardSkin;
      }
    }
    return null;
  }

  static ThemeSkinDefinition themeById(String id) {
    return tryThemeById(id) ?? themes.first;
  }

  static BoardSkinDefinition boardSkinById(String id) {
    return tryBoardSkinById(id) ?? boardSkins.first;
  }
}
