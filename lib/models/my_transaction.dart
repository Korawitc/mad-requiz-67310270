// lib/models/my_transaction.dart
class  Album {
  final int? id;
  final String title;
  final String artist;
  final int trackCount;
  final DateTime releaseDate;
  final bool isOwned;

  Album({
    this.id,
    required this.title,
    required this.artist,
    required this.trackCount,
    required this.releaseDate,
    required this.isOwned,
  });

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id, // ห้ามส่ง id ที่เป็น null เข้าไปใน UPDATE
      'title': title,
      'artist': artist,
      'trackCount': trackCount,
      'releaseDate': releaseDate.toIso8601String(),
      'isOwned': isOwned, // เก็บเป็น true หรือ false
    };
  }

  factory Album.fromMap(Map<String, dynamic> map) {
    return Album(
      id: map['id'] as int,
      title: map['title'] as String,
      artist: map['artist'] as String,
      trackCount: map['trackCount'] as int,
      releaseDate: DateTime.parse(map['releaseDate'] as String),
      isOwned: map['isOwned'] as bool,
    );
  }
}
