// lib/providers/transaction_provider.dart
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/my_transaction.dart';

class AlbumProvider with ChangeNotifier {
  static const String _dbName = 'albums.db';
  static const String _tableName = 'albums';
  Database? _database;
  List<Album> _albums = [];

  AlbumProvider() {
    fetchAndSetAlbums(); // โหลดข้อมูลเมื่อ Provider ถูกสร้าง
  }

  List<Album> get albums => [..._albums];

  // กระบวนการที่ 2: การสร้างฐานข้อมูล
  Future<void> _initDatabase() async {
    if (_database != null) return;
    try {
      final dbPath = await getDatabasesPath();
      final path = join(dbPath, _dbName);
      _database = await openDatabase(
        path,
        version: 1,
        onCreate: (db, version) {
          print('Creating table $_tableName...');
          return db.execute(
            'CREATE TABLE $_tableName(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, artist TEXT, trackCount INTEGER, releaseDate TEXT, isOwned BOOLEAN)',
          );
        },
      );
      print('Database initialized at $path');
    } catch (e) {
      print('Error initializing database: $e');
    }
  }

  // กระบวนการที่ 3: การ Insert
  Future<void> addAlbum(
    String title,
    String artist,
    int trackCount,
    DateTime releaseDate,
    bool isOwned,
  ) async {
    await _initDatabase(); // ตรวจสอบว่า DB พร้อมใช้งาน
    if (_database == null) return;

    final newAlbum = Album(
      title: title,
      artist: artist,
      trackCount: trackCount,
      releaseDate: releaseDate,
      isOwned: isOwned,
    );

    final id = await _database!.insert(_tableName, newAlbum.toMap());
    print('Inserted album with id: $id');
    await fetchAndSetAlbums();
  }

  // กระบวนการที่ 4: การ Read
  Future<void> fetchAndSetAlbums() async {
    await _initDatabase();
    if (_database == null) return;

    final dataList = await _database!.query(_tableName, orderBy: 'date DESC');
    _albums = dataList.map((item) => Album.fromMap(item)).toList();
    print('Fetched ${_albums.length} albums.');
    notifyListeners(); // แจ้ง UI ให้วาดใหม่
  }

  // กระบวนการที่ 5: การ Update
  Future<void> updateAlbum(int id, Album newAlbum) async {
    await _initDatabase();
    if (_database == null) return;
    await _database!.update(
      _tableName,
      newAlbum.toMap(), // toMap() ไม่ส่ง id ที่เป็น null จึงไม่ไปเปลี่ยนคีย์หลัก
      where: 'id = ?',
      whereArgs: [id],
    );
    await fetchAndSetAlbums();
  }

  // กระบวนการที่ 6: การ Delete
  Future<void> deleteAlbum(int id) async {
    await _initDatabase();
    if (_database == null) return;
    await _database!.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
    await fetchAndSetAlbums();
  }
}
