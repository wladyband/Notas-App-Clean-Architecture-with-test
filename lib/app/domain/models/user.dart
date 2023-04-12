import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@Freezed(toJson: false)
class User with _$User {
  const factory User({
    required String id,
    required String name,
    required String email,

  }) = _User;
  const User._();

  String getFormatted() {
    return '$name $id $email';
  }

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}


