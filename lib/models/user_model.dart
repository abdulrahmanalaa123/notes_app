class UserModel {
  final int id;
  final String? name;
  final String? email;

  const UserModel({
    required this.id,
    this.name,
    required this.email,
  });

  @override
  int get hashCode => id;
}
