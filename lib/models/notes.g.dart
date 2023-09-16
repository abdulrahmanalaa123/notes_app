// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notes.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Note _$NoteFromJson(Map<String, dynamic> json) => Note(
      id: json['id'] as int,
      //   userId: json['user_id'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
      noteData: NoteData.fromJson(json),
    );

Map<String, dynamic> _$NoteToJson(Note instance) {
  Map<String, dynamic> json = instance.noteData.toJson();
  json['id'] = instance.id;
  json['created_at'] = instance.createdAt.toIso8601String();
  return json;
}
