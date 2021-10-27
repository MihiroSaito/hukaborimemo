class MemoTable {
  final int? id;
  final int parentId;
  final String text;
  final int? tagId;
  final String? createdAt;
  final String updateAt;

  MemoTable({
    required this.id,
    required this.parentId,
    required this.text,
    required this.tagId,
    required this.createdAt,
    required this.updateAt,
  });

  Map<String, dynamic> insertMap() {
    return {
      'parent_id': parentId,
      'text': text,
      'tag_id': tagId,
      'created_at': createdAt,
      'updated_at': createdAt
    };
  }

  Map<String, dynamic> updateMap() {
    return {
      'parent_id': parentId,
      'text': text,
      'tag_id': tagId,
      'updated_at': updateAt
    };
  }

  static const String memoId = 'id';
  static const String memoParentId = 'parent_id';
  static const String memoText = 'text';
  static const String memoTagId = 'tag_id';
  static const String memoCreatedAt = 'created_at';
  static const String memoUpdatedAt = 'updated_at';

}

class TagTable {
  final int? id;
  final String name;
  final String usedAt;
  final String? createdAt;
  final String updatedAt;

  TagTable({
    required this.id,
    required this.name,
    required this.usedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> insertMap() {
    return {
      'name': name,
      'used_at': usedAt,
      'created_at': createdAt,
      'updated_at': createdAt
    };
  }

  Map<String, dynamic> updateMap() {
    return {
      'name': name,
      'used_at': usedAt,
      'updated_at': createdAt
    };
  }

  static const String tagId = 'id';
  static const String tagName = 'name';
  static const String tagUsedAt = 'used_at';
  static const String tagCreatedAt = 'created_at';
  static const String tagUpdatedAt = 'updated_at';
}
