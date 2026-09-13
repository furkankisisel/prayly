import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/foundation.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/entities/game_card.dart';

/// Gamification verileri için SQLite database
class GamificationDatabase {
  static Database? _database;
  static const String _databaseName = 'gamification.db';
  // Bump to 2 to add applied_events table migration
  static const int _databaseVersion = 2;

  // Table names
  static const String _userProfileTable = 'user_profile';
  static const String _gameCardsTable = 'game_cards';
  static const String _gameStatsTable = 'game_stats';
  // For tracking applied prayer events (to enable revert)
  static const String _appliedEventsTable = 'applied_events';

  /// Database instance'ını al
  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  /// Database'i başlat
  static Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _databaseName);

    debugPrint('Gamification DB: Database path: $path');

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _createDatabase,
      onUpgrade: _upgradeDatabase,
    );
  }

  /// Database tablolarını oluştur
  static Future<void> _createDatabase(Database db, int version) async {
    debugPrint('Gamification DB: Creating database v$version');

    // User Profile tablosu
    await db.execute('''
      CREATE TABLE $_userProfileTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        total_xp REAL NOT NULL,
        season_xp INTEGER NOT NULL,
        last_updated TEXT NOT NULL,
        metadata TEXT
      )
    ''');

    // Game Cards tablosu
    await db.execute('''
      CREATE TABLE $_gameCardsTable (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        type TEXT NOT NULL,
        category TEXT NOT NULL,
        rarity TEXT NOT NULL,
        progress REAL NOT NULL,
        xp_contributed REAL NOT NULL,
        ru_contributed REAL NOT NULL,
        last_updated TEXT NOT NULL,
        metadata TEXT
      )
    ''');

    // Game Stats tablosu (istatistikler için)
    await db.execute('''
      CREATE TABLE $_gameStatsTable (
        key TEXT PRIMARY KEY,
        value TEXT NOT NULL,
        last_updated TEXT NOT NULL
      )
    ''');

    // Applied events table (store payloads to allow revert)
    await db.execute('''
      CREATE TABLE $_appliedEventsTable (
        event_key TEXT PRIMARY KEY,
        payload TEXT NOT NULL,
        applied_at TEXT NOT NULL
      )
    ''');

    // (already created above inside _createDatabase)
    debugPrint('Gamification DB: Tables created successfully');
  }

  /// Database upgrade
  static Future<void> _upgradeDatabase(
    Database db,
    int oldVersion,
    int newVersion,
  ) async {
    debugPrint('Gamification DB: Upgrading from v$oldVersion to v$newVersion');
    // Migration: v2 adds applied_events table
    if (oldVersion < 2 && newVersion >= 2) {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS $_appliedEventsTable (
          event_key TEXT PRIMARY KEY,
          payload TEXT NOT NULL,
          applied_at TEXT NOT NULL
        )
      ''');
      debugPrint(
        'Gamification DB: applied_events table created during upgrade',
      );
    }
  }

  // ====================== USER PROFILE OPERATIONS ======================

  /// User profile kaydet
  static Future<void> saveUserProfile(UserProfile profile) async {
    final db = await database;

    await db.insert(_userProfileTable, {
      'total_xp': profile.totalXp,
      'season_xp': profile.seasonXp,
      'last_updated': profile.lastUpdated.toIso8601String(),
      'metadata': jsonEncode({}),
    }, conflictAlgorithm: ConflictAlgorithm.replace);

    debugPrint(
      'Gamification DB: User profile saved - XP: ${profile.totalXp}, Level: ${profile.level}',
    );
  }

  /// User profile yükle
  static Future<UserProfile?> getUserProfile() async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query(
      _userProfileTable,
      orderBy: 'id DESC',
      limit: 1,
    );

    if (maps.isNotEmpty) {
      final map = maps.first;
      final profile = UserProfile(
        totalXp: map['total_xp'] as double,
        seasonXp: map['season_xp'] as int,
        lastUpdated: DateTime.parse(map['last_updated'] as String),
      );

      debugPrint(
        'Gamification DB: User profile loaded - XP: ${profile.totalXp}, Level: ${profile.level}',
      );
      return profile;
    }

    return null;
  }

  // ====================== GAME CARDS OPERATIONS ======================

  /// Kart kaydet
  static Future<void> saveGameCard(GameCard card) async {
    final db = await database;

    await db.insert(_gameCardsTable, {
      'id': card.id,
      'title': card.title,
      'description': card.description,
      'type': card.type.name,
      'category': card.category.name,
      'rarity': card.rarity.name,
      'progress': card.progress,
      'xp_contributed': card.xpContributed,
      'ru_contributed': card.ruContributed,
      'last_updated': card.lastUpdated.toIso8601String(),
      'metadata': jsonEncode(card.metadata ?? {}),
    }, conflictAlgorithm: ConflictAlgorithm.replace);

    debugPrint('Gamification DB: Card saved - ${card.id}: ${card.progress}');
  }

  /// Tüm kartları kaydet
  static Future<void> saveAllGameCards(List<GameCard> cards) async {
    final db = await database;

    final batch = db.batch();
    for (final card in cards) {
      batch.insert(_gameCardsTable, {
        'id': card.id,
        'title': card.title,
        'description': card.description,
        'type': card.type.name,
        'category': card.category.name,
        'rarity': card.rarity.name,
        'progress': card.progress,
        'xp_contributed': card.xpContributed,
        'ru_contributed': card.ruContributed,
        'last_updated': card.lastUpdated.toIso8601String(),
        'metadata': jsonEncode(card.metadata ?? {}),
      }, conflictAlgorithm: ConflictAlgorithm.replace);
    }

    await batch.commit();
    debugPrint('Gamification DB: ${cards.length} cards saved in batch');
  }

  /// Tüm kartları yükle
  static Future<List<GameCard>> getAllGameCards() async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query(_gameCardsTable);

    final cards = maps.map((map) {
      return GameCard(
        id: map['id'] as String,
        title: map['title'] as String,
        description: map['description'] as String,
        type: GameCardType.values.firstWhere((e) => e.name == map['type']),
        category: GameCardCategory.values.firstWhere(
          (e) => e.name == map['category'],
        ),
        rarity: Rarity.values.firstWhere((e) => e.name == map['rarity']),
        progress: map['progress'] as double,
        xpContributed: map['xp_contributed'] as double,
        ruContributed: map['ru_contributed'] as double,
        lastUpdated: DateTime.parse(map['last_updated'] as String),
        metadata: map['metadata'] != null ? jsonDecode(map['metadata']) : null,
      );
    }).toList();

    debugPrint('Gamification DB: ${cards.length} cards loaded');
    return cards;
  }

  /// Belirli kategori kartlarını yükle
  static Future<List<GameCard>> getCardsByCategory(
    GameCardCategory category,
  ) async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query(
      _gameCardsTable,
      where: 'category = ?',
      whereArgs: [category.name],
    );

    return maps.map((map) {
      return GameCard(
        id: map['id'] as String,
        title: map['title'] as String,
        description: map['description'] as String,
        type: GameCardType.values.firstWhere((e) => e.name == map['type']),
        category: GameCardCategory.values.firstWhere(
          (e) => e.name == map['category'],
        ),
        rarity: Rarity.values.firstWhere((e) => e.name == map['rarity']),
        progress: map['progress'] as double,
        xpContributed: map['xp_contributed'] as double,
        ruContributed: map['ru_contributed'] as double,
        lastUpdated: DateTime.parse(map['last_updated'] as String),
        metadata: map['metadata'] != null ? jsonDecode(map['metadata']) : null,
      );
    }).toList();
  }

  /// Tek bir kartı yükle
  static Future<GameCard?> getGameCard(String cardId) async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query(
      _gameCardsTable,
      where: 'id = ?',
      whereArgs: [cardId],
      limit: 1,
    );

    if (maps.isNotEmpty) {
      final map = maps.first;
      return GameCard(
        id: map['id'] as String,
        title: map['title'] as String,
        description: map['description'] as String,
        type: GameCardType.values.firstWhere((e) => e.name == map['type']),
        category: GameCardCategory.values.firstWhere(
          (e) => e.name == map['category'],
        ),
        rarity: Rarity.values.firstWhere((e) => e.name == map['rarity']),
        progress: map['progress'] as double,
        xpContributed: map['xp_contributed'] as double,
        ruContributed: map['ru_contributed'] as double,
        lastUpdated: DateTime.parse(map['last_updated'] as String),
        metadata: map['metadata'] != null ? jsonDecode(map['metadata']) : null,
      );
    }

    return null;
  }

  // ====================== GAME STATS OPERATIONS ======================

  /// İstatistik kaydet
  static Future<void> saveGameStat(String key, String value) async {
    final db = await database;

    await db.insert(_gameStatsTable, {
      'key': key,
      'value': value,
      'last_updated': DateTime.now().toIso8601String(),
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  /// İstatistik yükle
  static Future<String?> getGameStat(String key) async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query(
      _gameStatsTable,
      where: 'key = ?',
      whereArgs: [key],
      limit: 1,
    );

    if (maps.isNotEmpty) {
      return maps.first['value'] as String;
    }

    return null;
  }

  /// Save an applied event payload for potential revert
  static Future<void> saveAppliedEvent(String eventKey, String payload) async {
    final db = await database;
    await db.insert(_appliedEventsTable, {
      'event_key': eventKey,
      'payload': payload,
      'applied_at': DateTime.now().toIso8601String(),
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  /// Get applied event by key
  static Future<Map<String, dynamic>?> getAppliedEvent(String eventKey) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      _appliedEventsTable,
      where: 'event_key = ?',
      whereArgs: [eventKey],
      limit: 1,
    );
    if (maps.isNotEmpty) return maps.first;
    return null;
  }

  /// Delete applied event (after revert)
  static Future<void> deleteAppliedEvent(String eventKey) async {
    final db = await database;
    await db.delete(
      _appliedEventsTable,
      where: 'event_key = ?',
      whereArgs: [eventKey],
    );
  }

  // ====================== MAINTENANCE OPERATIONS ======================

  /// Tüm gamification verilerini sil
  static Future<void> clearAllData() async {
    final db = await database;

    await db.delete(_userProfileTable);
    await db.delete(_gameCardsTable);
    await db.delete(_gameStatsTable);

    debugPrint('Gamification DB: All data cleared');
  }

  /// Database'i kapat
  static Future<void> closeDatabase() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
      debugPrint('Gamification DB: Database closed');
    }
  }

  /// Database backup/export (future use)
  static Future<Map<String, dynamic>> exportData() async {
    final db = await database;

    final profiles = await db.query(_userProfileTable);
    final cards = await db.query(_gameCardsTable);
    final stats = await db.query(_gameStatsTable);

    return {
      'profiles': profiles,
      'cards': cards,
      'stats': stats,
      'exported_at': DateTime.now().toIso8601String(),
    };
  }
}
