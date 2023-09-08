// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notes.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Note _$NoteFromJson(Map<String, dynamic> json) => Note(
      id: json['id'] as int,
      //   userId: json['user_id'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
      title: json['title'] as String,
      lastEdited: json['last_edited'] == null
          ? null
          : DateTime.parse(json['last_edited'] as String),
      body: json['body'] as String? ?? '',
      description: json['description'] as String? ?? '',
      imgPaths: (json['image_list'] as List<dynamic>?)
          ?.map((e) => ImageModel.fromRow(e))
          .toList(),
      isFavorite: json['is_favorite'] as int?,
    );

Map<String, dynamic> _$NoteToJson(Note instance) => <String, dynamic>{
      'id': instance.id,
      // 'user_id': instance.userId,
      'created_at': instance.createdAt.toIso8601String(),
      'last_edited': instance.lastEdited?.toIso8601String(),
      'title': instance.title,
      'body': instance.body,
      'description': instance.description,
      'image_list_id': instance.imgPaths,
      'is_favorite': instance.isFavorite.toString(),
    };
