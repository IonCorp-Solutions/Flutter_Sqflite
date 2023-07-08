import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:anime_app/api/model.dart';

class DatabaseProvider {
  static const String databaseName = 'anime.db';
  static const int databaseVersion = 1;

  static const String animeTable = 'anime';
  static const String columnId = 'mal_id';
  static const String columnTitle = 'title';
  static const String columnImage = 'image';
  static const String columnYear = 'year';

  static Future<Database> open() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, databaseName);

    return openDatabase(
      path,
      version: databaseVersion,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $animeTable (
            $columnId INTEGER PRIMARY KEY,
            $columnTitle TEXT,
            $columnImage TEXT,
            $columnYear INTEGER
          )
        ''');
      },
    );
  }

  static Future<void> insertAnime(Anime anime) async {
    final db = await open();

    await db.insert(
      animeTable,
      anime.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Anime>> getFavoriteAnimes() async {
    final db = await open();

    final List<Map<String, dynamic>> maps = await db.query(animeTable);

    return List.generate(maps.length, (index) {
      return Anime.fromMap(maps[index]);
    });
  }

  static Future<void> deleteAnime(int malId) async {
    final db = await open();

    await db.delete(
      animeTable,
      where: '$columnId = ?',
      whereArgs: [malId],
    );
  }
}
