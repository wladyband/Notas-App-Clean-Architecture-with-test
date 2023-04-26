import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_registrarion_state.freezed.dart';

@freezed
class ProductRegistrationState with _$ProductRegistrationState {
  const factory ProductRegistrationState({
    @Default('') String name,
    @Default(0) num price,
    @Default(0) int quantity,
    @Default(false) bool fetching,
  }) = _ProductRegistrationState;
}
