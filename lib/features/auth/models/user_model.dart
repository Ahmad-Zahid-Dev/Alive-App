/// Represents an authenticated user.
class UserModel {
  const UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.photoUrl,
  });

  final String uid;
  final String name;
  final String email;
  final String photoUrl;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        uid: json['uid'] as String? ?? '',
        name: json['name'] as String? ?? '',
        email: json['email'] as String? ?? '',
        photoUrl: json['photoUrl'] as String? ?? '',
      );

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'name': name,
        'email': email,
        'photoUrl': photoUrl,
      };

  UserModel copyWith({
    String? uid,
    String? name,
    String? email,
    String? photoUrl,
  }) =>
      UserModel(
        uid: uid ?? this.uid,
        name: name ?? this.name,
        email: email ?? this.email,
        photoUrl: photoUrl ?? this.photoUrl,
      );

  @override
  String toString() => 'UserModel(uid: $uid, name: $name, email: $email)';
}
