import 'dart:convert';

import 'app_enums.dart';
import 'game_session.dart';

class PlayerStats {
  const PlayerStats({
    this.totalGames = 0,
    this.dailyGames = 0,
    this.quickGames = 0,
    this.perfectGames = 0,
    this.totalMistakes = 0,
    this.totalHintsUsed = 0,
    this.totalElapsedSeconds = 0,
    this.totalCoinsEarned = 0,
    this.bestDailySeconds,
    this.bestQuickEasySeconds,
    this.bestQuickMediumSeconds,
    this.lastPlayedDateKey,
  });

  final int totalGames;
  final int dailyGames;
  final int quickGames;
  final int perfectGames;
  final int totalMistakes;
  final int totalHintsUsed;
  final int totalElapsedSeconds;
  final int totalCoinsEarned;
  final int? bestDailySeconds;
  final int? bestQuickEasySeconds;
  final int? bestQuickMediumSeconds;
  final String? lastPlayedDateKey;

  PlayerStats copyWith({
    int? totalGames,
    int? dailyGames,
    int? quickGames,
    int? perfectGames,
    int? totalMistakes,
    int? totalHintsUsed,
    int? totalElapsedSeconds,
    int? totalCoinsEarned,
    int? bestDailySeconds,
    int? bestQuickEasySeconds,
    int? bestQuickMediumSeconds,
    String? lastPlayedDateKey,
    bool clearLastPlayedDateKey = false,
  }) {
    return PlayerStats(
      totalGames: totalGames ?? this.totalGames,
      dailyGames: dailyGames ?? this.dailyGames,
      quickGames: quickGames ?? this.quickGames,
      perfectGames: perfectGames ?? this.perfectGames,
      totalMistakes: totalMistakes ?? this.totalMistakes,
      totalHintsUsed: totalHintsUsed ?? this.totalHintsUsed,
      totalElapsedSeconds: totalElapsedSeconds ?? this.totalElapsedSeconds,
      totalCoinsEarned: totalCoinsEarned ?? this.totalCoinsEarned,
      bestDailySeconds: bestDailySeconds ?? this.bestDailySeconds,
      bestQuickEasySeconds: bestQuickEasySeconds ?? this.bestQuickEasySeconds,
      bestQuickMediumSeconds:
          bestQuickMediumSeconds ?? this.bestQuickMediumSeconds,
      lastPlayedDateKey: clearLastPlayedDateKey
          ? null
          : (lastPlayedDateKey ?? this.lastPlayedDateKey),
    );
  }

  PlayerStats recordSession(
    GameSession session, {
    required int coinsEarned,
    required String playedDateKey,
  }) {
    int? nextBestDaily = bestDailySeconds;
    int? nextBestEasy = bestQuickEasySeconds;
    int? nextBestMedium = bestQuickMediumSeconds;

    if (session.kind == GameKind.daily) {
      nextBestDaily = _pickBest(bestDailySeconds, session.elapsedSeconds);
    } else {
      switch (session.puzzle.difficulty) {
        case PuzzleDifficulty.easy:
          nextBestEasy = _pickBest(bestQuickEasySeconds, session.elapsedSeconds);
          break;
        case PuzzleDifficulty.medium:
          nextBestMedium =
              _pickBest(bestQuickMediumSeconds, session.elapsedSeconds);
          break;
      }
    }

    return PlayerStats(
      totalGames: totalGames + 1,
      dailyGames: dailyGames + (session.kind == GameKind.daily ? 1 : 0),
      quickGames: quickGames + (session.kind == GameKind.regular ? 1 : 0),
      perfectGames: perfectGames + (session.mistakes == 0 ? 1 : 0),
      totalMistakes: totalMistakes + session.mistakes,
      totalHintsUsed: totalHintsUsed + session.hintsUsed,
      totalElapsedSeconds: totalElapsedSeconds + session.elapsedSeconds,
      totalCoinsEarned: totalCoinsEarned + (coinsEarned < 0 ? 0 : coinsEarned),
      bestDailySeconds: nextBestDaily,
      bestQuickEasySeconds: nextBestEasy,
      bestQuickMediumSeconds: nextBestMedium,
      lastPlayedDateKey: playedDateKey,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalGames': totalGames,
      'dailyGames': dailyGames,
      'quickGames': quickGames,
      'perfectGames': perfectGames,
      'totalMistakes': totalMistakes,
      'totalHintsUsed': totalHintsUsed,
      'totalElapsedSeconds': totalElapsedSeconds,
      'totalCoinsEarned': totalCoinsEarned,
      'bestDailySeconds': bestDailySeconds,
      'bestQuickEasySeconds': bestQuickEasySeconds,
      'bestQuickMediumSeconds': bestQuickMediumSeconds,
      'lastPlayedDateKey': lastPlayedDateKey,
    };
  }

  String toStorage() => jsonEncode(toJson());

  static PlayerStats fromStorage(String? raw) {
    if (raw == null || raw.isEmpty) {
      return const PlayerStats();
    }
    final json = jsonDecode(raw);
    if (json is! Map<String, dynamic>) {
      return const PlayerStats();
    }
    return PlayerStats(
      totalGames: json['totalGames'] as int? ?? 0,
      dailyGames: json['dailyGames'] as int? ?? 0,
      quickGames: json['quickGames'] as int? ?? 0,
      perfectGames: json['perfectGames'] as int? ?? 0,
      totalMistakes: json['totalMistakes'] as int? ?? 0,
      totalHintsUsed: json['totalHintsUsed'] as int? ?? 0,
      totalElapsedSeconds: json['totalElapsedSeconds'] as int? ?? 0,
      totalCoinsEarned: json['totalCoinsEarned'] as int? ?? 0,
      bestDailySeconds: _nullableInt(json['bestDailySeconds']),
      bestQuickEasySeconds: _nullableInt(json['bestQuickEasySeconds']),
      bestQuickMediumSeconds: _nullableInt(json['bestQuickMediumSeconds']),
      lastPlayedDateKey: json['lastPlayedDateKey'] as String?,
    );
  }

  static int? _pickBest(int? current, int candidate) {
    if (current == null || candidate < current) {
      return candidate;
    }
    return current;
  }

  static int? _nullableInt(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    return null;
  }
}
