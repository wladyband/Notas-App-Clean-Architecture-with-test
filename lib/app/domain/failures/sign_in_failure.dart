import 'package:freezed_annotation/freezed_annotation.dart';

part 'sign_in_failure.freezed.dart';

@freezed
class SignInFailure with _$SignInFailure {
  factory SignInFailure.notFound() = NotFound;
  factory SignInFailure.invalidEmail() = InvalidEmail;
  factory SignInFailure.network() = Network;
  factory SignInFailure.unauthorized() = Unauthorized;
  factory SignInFailure.unknown() = Unknown;
}
