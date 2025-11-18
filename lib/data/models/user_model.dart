import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel extends Equatable {
  final String id;
  final String email;
  final String? name;
  final String? photoUrl;
  final bool isAdmin;

  const UserModel({
    required this.id,
    required this.email,
    this.name,
    this.photoUrl,
    this.isAdmin = false,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  // Check if user is admin based on email
  static bool checkIsAdmin(String email) {
    const adminEmails = ['admin@gmail.com', 'admin@homeshop.com'];
    return adminEmails.contains(email.toLowerCase());
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? name,
    String? photoUrl,
    bool? isAdmin,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      photoUrl: photoUrl ?? this.photoUrl,
      isAdmin: isAdmin ?? this.isAdmin,
    );
  }

  @override
  List<Object?> get props => [id, email, name, photoUrl, isAdmin];
}
