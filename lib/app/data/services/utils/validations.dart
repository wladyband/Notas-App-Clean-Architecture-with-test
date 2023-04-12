mixin Validations {
  String? isNotEmpty(String? value, [String? message]) {
    value = value?.trim().toLowerCase();
    if (value!.isEmpty) {
      return message ?? 'This field is mandatory';
    }
    return null;
  }

  String? validatorNumber(String? value, int characterSize, [String? message]) {
    value = value?.replaceAll(' ', '').toLowerCase();
    if (value!.length < characterSize) {
      return 'Invalid password';
    }
    return null;
  }

  String? combiner(List<String? Function()> validators) {
    for (final allFunctions in validators) {
      final validations = allFunctions();
      if (validations != null) {
        return validations;
      }
    }
    return null;
  }
}
