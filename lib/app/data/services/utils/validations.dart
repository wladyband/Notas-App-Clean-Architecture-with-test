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

  String? isNumeric(String? value, [String? message]) {
    if (value == null) {
      return message ?? 'This field is required';
    }

    final numericRegex = RegExp(r'^\d+([\.,]\d+)?$');
    if (!numericRegex.hasMatch(value)) {
      return message ?? 'This field must contain only numbers';
    }

    try {
      num.parse(value.replaceAll(',', '.'));
    } catch (_) {
      return message ?? 'This field must be a valid number';
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
