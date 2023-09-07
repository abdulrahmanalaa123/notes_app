class UserModel implements Comparable {
  final String id;
  final String? name;
  final String? email;
  final String? imagePath;

  const UserModel({
    required this.id,
    this.name,
    required this.email,
    this.imagePath,
  });

  @override
  int compareTo(other) => other.id.compareTo(id);

  @override
  bool operator ==(covariant UserModel other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}
