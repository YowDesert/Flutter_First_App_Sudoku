import 'dart:convert';

class PlayerInventory {
  const PlayerInventory({
    required this.coins,
    required this.ownedThemes,
    required this.equippedThemeId,
    required this.ownedBoardSkins,
    required this.equippedBoardSkinId,
  });

  final int coins;
  final Set<String> ownedThemes;
  final String equippedThemeId;
  final Set<String> ownedBoardSkins;
  final String equippedBoardSkinId;

  factory PlayerInventory.initial({
    required String defaultThemeId,
    required String defaultBoardSkinId,
    int startingCoins = 120,
  }) {
    return PlayerInventory(
      coins: startingCoins,
      ownedThemes: <String>{defaultThemeId},
      equippedThemeId: defaultThemeId,
      ownedBoardSkins: <String>{defaultBoardSkinId},
      equippedBoardSkinId: defaultBoardSkinId,
    );
  }

  PlayerInventory copyWith({
    int? coins,
    Set<String>? ownedThemes,
    String? equippedThemeId,
    Set<String>? ownedBoardSkins,
    String? equippedBoardSkinId,
  }) {
    return PlayerInventory(
      coins: coins ?? this.coins,
      ownedThemes: ownedThemes ?? this.ownedThemes,
      equippedThemeId: equippedThemeId ?? this.equippedThemeId,
      ownedBoardSkins: ownedBoardSkins ?? this.ownedBoardSkins,
      equippedBoardSkinId: equippedBoardSkinId ?? this.equippedBoardSkinId,
    );
  }

  Map<String, dynamic> toJson() {
    final themeList = ownedThemes.toList()..sort();
    final boardList = ownedBoardSkins.toList()..sort();
    return {
      'coins': coins,
      'ownedThemes': themeList,
      'equippedThemeId': equippedThemeId,
      'ownedBoardSkins': boardList,
      'equippedBoardSkinId': equippedBoardSkinId,
    };
  }

  String toStorage() => jsonEncode(toJson());

  static PlayerInventory fromStorage(
    String? raw, {
    required String defaultThemeId,
    required String defaultBoardSkinId,
    int startingCoins = 120,
  }) {
    if (raw == null || raw.isEmpty) {
      return PlayerInventory.initial(
        defaultThemeId: defaultThemeId,
        defaultBoardSkinId: defaultBoardSkinId,
        startingCoins: startingCoins,
      );
    }

    final parsed = jsonDecode(raw);
    if (parsed is! Map<String, dynamic>) {
      return PlayerInventory.initial(
        defaultThemeId: defaultThemeId,
        defaultBoardSkinId: defaultBoardSkinId,
        startingCoins: startingCoins,
      );
    }

    final ownedThemes = ((parsed['ownedThemes'] as List<dynamic>?) ?? const [])
        .cast<String>()
        .toSet();
    final ownedBoardSkins =
        ((parsed['ownedBoardSkins'] as List<dynamic>?) ?? const [])
            .cast<String>()
            .toSet();

    final equippedThemeId =
        parsed['equippedThemeId'] as String? ?? defaultThemeId;
    final equippedBoardSkinId =
        parsed['equippedBoardSkinId'] as String? ?? defaultBoardSkinId;

    ownedThemes.add(defaultThemeId);
    ownedBoardSkins.add(defaultBoardSkinId);
    ownedThemes.add(equippedThemeId);
    ownedBoardSkins.add(equippedBoardSkinId);

    return PlayerInventory(
      coins: parsed['coins'] as int? ?? startingCoins,
      ownedThemes: ownedThemes,
      equippedThemeId: equippedThemeId,
      ownedBoardSkins: ownedBoardSkins,
      equippedBoardSkinId: equippedBoardSkinId,
    );
  }
}
