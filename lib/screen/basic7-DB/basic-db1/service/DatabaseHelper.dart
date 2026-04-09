import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../model/Note.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  Database? _db;

  Future<Database> get database async {
    _db ??= await _initDatabase();
    return _db!;
  }

  Future<Database> _initDatabase() async {
    final docDir = await getApplicationDocumentsDirectory();
    final dbPath = path.join(docDir.path, 'notes.db');
    return openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, _) async {
        await db.execute('''
          CREATE TABLE notes (
            id        INTEGER PRIMARY KEY AUTOINCREMENT,
            title     TEXT NOT NULL,
            content   TEXT NOT NULL,
            createdAt TEXT NOT NULL
          )
        ''');
      },
    );
  }

  // CREATE
  Future<int> insertNote(Note note) async {
    final db = await database;
    return db.insert('notes', note.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // READ - 검색 키워드 + 페이지네이션(limit/offset) 지원
  Future<List<Note>> getNotes({
    String keyword = '',
    int limit = 10,
    int offset = 0,
  }) async {
    final db = await database;
    if (keyword.isEmpty) {
      return (await db.query(
        'notes',
        orderBy: 'id DESC',
        limit: limit,
        offset: offset,
      )).map(Note.fromMap).toList();
    }
    // 제목 또는 내용에 키워드 포함 → LIKE 검색
    return (await db.rawQuery(
      'SELECT * FROM notes WHERE title LIKE ? OR content LIKE ? ORDER BY id DESC LIMIT ? OFFSET ?',
      ['%$keyword%', '%$keyword%', limit, offset],
    )).map(Note.fromMap).toList();
  }

  // 전체 건수 조회 (페이지 수 계산용)
  Future<int> getCount({String keyword = ''}) async {
    final db = await database;
    final result = keyword.isEmpty
        ? await db.rawQuery('SELECT COUNT(*) as cnt FROM notes')
        : await db.rawQuery(
      'SELECT COUNT(*) as cnt FROM notes WHERE title LIKE ? OR content LIKE ?',
      ['%$keyword%', '%$keyword%'],
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  // UPDATE
  Future<int> updateNote(Note note) async {
    final db = await database;
    return db.update('notes', note.toMap(),
        where: 'id = ?', whereArgs: [note.id]);
  }

  // DELETE
  Future<int> deleteNote(int id) async {
    final db = await database;
    return db.delete('notes', where: 'id = ?', whereArgs: [id]);
  }

  // service/DatabaseHelper.dart 에 추가

  /// 더미 데이터 일괄 삽입 (트랜잭션 활용)
  Future<void> insertDummyNotes({int count = 30}) async {
    const categories = ['업무', '개인', '학습', '쇼핑', '여행'];
    const bodies = [
      'Flutter 위젯 공부하기',
      '장보기 목록 정리',
      '프로젝트 일정 확인',
      '독서 30분',
      '운동 계획 세우기',
      '회의 자료 준비',
      '이메일 확인 및 답장',
      'GitHub 커밋 정리',
      '주간 보고서 작성',
      '코드 리뷰 진행',
    ];

    final db = await database;
    final now = DateTime.now();

    // 트랜잭션: 여러 INSERT를 하나의 작업으로 묶어 성능 향상
    await db.transaction((txn) async {
      for (int i = 0; i < count; i++) {
        final category = categories[i % categories.length];
        await txn.insert(
          'notes',
          Note(
            title: '[$category] 더미 노트 ${i + 1}',
            content: bodies[i % bodies.length],
            createdAt: now
                .subtract(Duration(hours: i * 2))
                .toIso8601String(),
          ).toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    });
  }
}