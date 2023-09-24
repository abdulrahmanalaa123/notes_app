import 'package:json_annotation/json_annotation.dart';
import 'notes_data.dart';
part 'notes.g.dart';

@JsonSerializable()
class Note implements Comparable {
  late int? id;
  //@JsonKey(name: 'user_id')
  //final int userId;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'last_edited')
  NoteData noteData;

  Note({
    //id is nullable since it cant be defined by my app it needs to be defined by the database
    this.id,
    required this.createdAt,
    required this.noteData,
  }) {
    //this will be created if read note
    //has been created only and never edited
    if (noteData.lastEdited == null) {
      noteData.creationTime(createdAt: createdAt);
    }
  }

  void setId(int newId) {
    // if id is not set yet
    //supposedly it will set it only once
    id ??= newId;
  }

  @override
  //it will not be null ever since at least it will be equal created at time
  int compareTo(covariant other) =>
      noteData.lastEdited!.compareTo(other.noteData.lastEdited);

  //compare to another note if not just compare it to ''
  //i guess this works idk yet
  int compareByText(covariant Note other) =>
      noteData.body.compareTo(other.noteData.body);
  int compareByTitle(covariant Note other) =>
      noteData.title.compareTo(other.noteData.title);
  @override
  bool operator ==(covariant Note other) => hashCode == other.hashCode;
  @override
  // TODO: implement hashCode
  int get hashCode => id.hashCode;

  factory Note.fromJson(Map<String, dynamic> json) => _$NoteFromJson(json);

  Map<String, dynamic> toJson() => _$NoteToJson(this);

  Map<String, dynamic> toRow() {
    //these are what we need in a database row altogether
    Map<String, dynamic> initialMap = noteData.toRow();
    initialMap['created_at'] = createdAt.toIso8601String();
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
      noteData: NoteData.fromRow(row));
}
