import 'dart:ui';

import 'group.dart';
import 'image_model.dart';

class NoteData {
  DateTime? lastEdited;
  String title;
  String body;
  //shortened text describing note
  String? description;
  List<ImageModel>? imgPaths;
  List<Group>? groups;
  int isFavorite;
  Color color;

  NoteData({
    required this.title,
    this.body = '',
    this.description,
    this.imgPaths,
    this.isFavorite = 0,
    this.lastEdited,
    this.groups,
    required this.color,
  }) {
    imgPaths ??= <ImageModel>[];
    groups ??= <Group>[];

    //if description is null either assign it '' if body is null and dont if it isnt
    //which will be given from the above constructor
    description ??= (body.length > 100)
        ? '${body.substring(0, (body.length ~/ 3))}...'
        : body;
  }

  //used only once after initialization to equate lastEdited to createdAt
  //just so when initializing Note object you don't have to type createdAt two times
  void creationTime({required DateTime createdAt}) {
    lastEdited = createdAt;
  }

  //is it better to seperate or just add all to one interface?
  //ill leave it as is for now
  void editFields({
    String? newName,
    String? newText,
    String? newDescription,
    int? favorite,
    Color? newColor,
  }) {
    //easier than typing if newX is null the problem it performs an overhead of reassigning but i dont think it would be an issue
    title = newName ?? title;
    body = newText ?? body;
    description = newDescription ?? description;
    isFavorite = favorite ?? isFavorite;
    color = newColor ?? color;
    lastEdited = DateTime.now();
  }

  void addImage({required List<ImageModel> imgPath}) {
    //why does it need a null check since i already check for nulls firsthand?!
    imgPaths!.addAll(imgPath);
  }

  void deleteImage({required ImageModel imgPath}) {
    imgPaths!.remove(imgPath);
  }

  void addToGroup({required List<Group> newGroups}) {
    groups!.addAll(newGroups);
  }

  void removeFromGroup({required Group group}) {
    groups!.remove(group);
  }

  bool hasGroup({required Group group}) {
    List<Group>? nullCheckableGroups = groups;
    if (nullCheckableGroups != null) {
      return nullCheckableGroups.contains(group);
    } else {
      return false;
    }
  }

  Map<String, dynamic> toRow() {
    //these are what we need in a database row altogether
    Map<String, dynamic> initialMap = {
      'title': title,
      'body': body,
      'description': description,
      'is_favorite': isFavorite,
      'last_edited': lastEdited?.toIso8601String(),
      'color': color.value,
    };
    return initialMap;
  }

  factory NoteData.fromRow(Map<String, dynamic> row) {
    NoteData noteData = NoteData(
      title: row['title'] as String,
      body: row['body'] as String,
      description: row['description'] as String? ?? '',
      isFavorite: row['is_favorite'] as int,
      lastEdited: row['last_edited'] == null
          ? null
          : DateTime.parse(
              row['last_edited'] as String,
            ),
      color: Color(row['color'] as int),
    );

    return noteData;
  }

  factory NoteData.fromJson(Map<String, dynamic> json) => NoteData(
        title: json['title'] as String,
        lastEdited: json['last_edited'] == null
            ? null
            : DateTime.parse(json['last_edited'] as String),
        body: json['body'] as String,
        description: json['description'] as String? ?? '',
        imgPaths: (json['image_list'] as List<dynamic>?)
            ?.map((e) => ImageModel.fromRow(e))
            .toList(),
        isFavorite: json['is_favorite'] as int,
        groups: (json['groups'] as List<dynamic>?)
            ?.map((e) => Group.fromRow(e))
            .toList(),
        color: Color(json['color'] as int),
      );

  Map<String, dynamic> toJson() {
    //these are what we need in a database row altogether
    Map<String, dynamic> initialMap = {
      'title': title,
      'body': body,
      'description': description,
      'is_favorite': isFavorite,
      'image_list': imgPaths,
      'group_list': groups,
      'last_edited': lastEdited?.toIso8601String(),
      'color': color.value,
    };

    return initialMap;
  }

  factory NoteData.copy(NoteData other) => NoteData(
      title: other.title,
      body: other.body,
      description: other.description,
      imgPaths: other.imgPaths,
      isFavorite: other.isFavorite,
      lastEdited: other.lastEdited,
      groups: other.groups,
      color: other.color);
}
