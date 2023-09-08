import 'package:json_annotation/json_annotation.dart';
import 'package:notes_app/models/image_model.dart';
part 'notes.g.dart';

@JsonSerializable()
class Note implements Comparable {
  late final int? id;
  //@JsonKey(name: 'user_id')
  //final int userId;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'last_edited')
  DateTime? lastEdited;
  @JsonKey(name: 'title')
  String title;
  @JsonKey(defaultValue: '')
  String? body;
  //shortened text describing note
  @JsonKey(defaultValue: '')
  String? description;
  List<ImageModel>? imgPaths;
  @JsonKey(name: 'is_favorite')
  int? isFavorite;

  Note({
    //id is nullable since it cant be defined by my app it needs to be defined by the database
    this.id,
    //userId isnt needed and it will probably be in the helper
    //as a provider listener
    //could add a shared with if i decide to add sharing but for now its not needed
    //required this.userId,
    required this.createdAt,
    required this.title,
    this.lastEdited,
    this.body,
    this.description,
    this.imgPaths,
    this.isFavorite,
  }) {
    //if description is null either assign it '' if body is null and dont if it isnt
    //which will be given from the above constructor
    description ??=
        body != null ? '${body!.substring(0, (body!.length ~/ 3))}...' : '';
    body ??= '';
    isFavorite ??= 0;
    lastEdited ??= createdAt;
  }

  void setId(int newId) {
    // if id is not set yet
    //supposedly it will set it only once
    id ??= newId;
  }

  //is it better to seperate or just add all to one interface?
  //ill leave it as is for now
  void editFields(
      {String? newName,
      String? newText,
      String? newDescription,
      int? favorite}) {
    //easier than typing if newX is null the problem it performs an overhead of reassigning but i dont think it would be an issue
    title = newName ?? title;
    body = newText ?? body;
    description = newDescription ?? description;
    isFavorite = favorite ?? isFavorite;
    lastEdited = DateTime.now();
  }

  void addImage({required List<ImageModel> imgPath}) {
    imgPaths ??= <ImageModel>[];
    //why does it need a null check since i already check for nulls firsthand?!
    imgPaths?.addAll(imgPath);
  }

  void deleteImage({required ImageModel imgPath}) {
    imgPaths?.remove(imgPath);
  }

  //compare datetime
  //
  @override
  //it will not be null ever since at least it will be equal created at time
  int compareTo(covariant other) => lastEdited!.compareTo(other.lastEdited);

  //compare to another note if not just compare it to ''
  //i guess this works idk yet
  int compareByText(covariant Note other) => body!.compareTo(other.body ?? '');

  @override
  bool operator ==(covariant Note other) => hashCode == other.hashCode;
  @override
  // TODO: implement hashCode
  int get hashCode => id.hashCode;

  factory Note.fromJson(Map<String, dynamic> json) => _$NoteFromJson(json);

  Map<String, dynamic> toJson() => _$NoteToJson(this);

  Map<String, dynamic> toRow() {
    //these are what we need in a database row altogether
    Map<String, dynamic> initialMap = {
      //    'user_id': userId,
      'created_at': createdAt.toIso8601String(),
      'title': title,
      'body': body,
      'description': description,
      'is_favorite': isFavorite,
    };
    if (lastEdited != null) {
      initialMap['last_edited'] = lastEdited?.toIso8601String();
    }
    //this would help not creating two rows of the same note
    //if i've already given it an id which would help
    //in failure of transactions without using them
    if (id != null) {
      initialMap['id'] = id;
    }
    return initialMap;
  }

  factory Note.fromRow(Map<String, dynamic> row) => Note(
        id: row['id'] as int,
//        userId: row['user_id'] as int,
        createdAt: DateTime.parse(row['created_at'] as String),
        title: row['title'] as String,
        lastEdited: row['last_edited'] == null
            ? null
            : DateTime.parse(row['last_edited'] as String),
        body: row['body'] as String? ?? '',
        description: row['description'] as String? ?? '',
        isFavorite: row['is_favorite'] as int?,
      );
}
