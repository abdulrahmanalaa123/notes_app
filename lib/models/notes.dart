import 'package:json_annotation/json_annotation.dart';
part 'notes.g.dart';

@JsonSerializable()
class Note implements Comparable {
  final int? id;
  @JsonKey(name: 'user_id')
  final int userId;
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
  @JsonKey(name: 'image_list_id')
  List<String>? imgPaths;
  @JsonKey(name: 'is_favorite')
  bool? isFavorite;
  Note({
    //id is nullable since it cant be defined by my app it needs to be defined by the database
    this.id,
    //could be removeable and put in the notes list class
    required this.userId,
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
    isFavorite ??= false;
    lastEdited ??= createdAt;
  }

  //is it better to seperate or just add all to one interface?
  //ill leave it as is for now
  void editFields({String? newName, String? newText, String? newDescription}) {
    //easier than typing if newX is null the problem it performs an overhead of reassigning but i dont think it would be an issue
    title = newName ?? title;
    body = newText ?? body;
    description = newDescription ?? description;
    lastEdited = DateTime.now();
  }

  void addImage({required String imgPath}) {
    imgPaths ??= <String>[];
    //why does it need a null check since i already check for nulls firsthand?!
    imgPaths?.add(imgPath);
  }

  void deleteImage({required String imgPath}) {
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
}
