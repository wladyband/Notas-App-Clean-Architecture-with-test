import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_update_state.freezed.dart';

@freezed
class ProductUpdateState with _$ProductUpdateState {
  const factory ProductUpdateState({
    @Default('') String id,
    @Default('') String name,
    @Default(0) num price,
    @Default(0) int quantity,
    @Default(false) bool fetching,
  }) = _ProductUpdateState;
}
