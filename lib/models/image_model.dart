class ImageModel {
  int? id;
  final String path;

  ImageModel({required this.path, this.id});

  void setId(int newId) {
    id ??= newId;
  }

  factory ImageModel.fromRow(Map<String, dynamic> row) {
    return ImageModel(path: row['path'], id: row['id']);
  }

  Map<String, dynamic> toRow() {
    Map<String, dynamic> initialMap = {
      'path': path,
    };
    if (id != null) initialMap['id'] = id;
    return initialMap;
  }
}
