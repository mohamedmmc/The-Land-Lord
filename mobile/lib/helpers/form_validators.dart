import 'package:validators/validators.dart';

class FormValidators {
  static const minPasswordNumberOfCharacters = 3;

  static String? notNullObjectValidator(Object? value) {
    if (value == null) return 'Field cannot be empty!';
    return null;
  }

  static String? notEmptyOrNullValidator(String? value) {
    value = value?.toLowerCase().trim();
    if (value == null || value.isEmpty) return 'Field cannot be empty!';
    return null;
  }

  static String? notEmptyOrNullIntValidator(String? value) {
    value = value?.toLowerCase().trim();
    if (value == null || value.isEmpty) return 'Field cannot be empty!';
    if (!isInt(value)) return 'Invalid number!';
    return null;
  }

  static String? notEmptyOrNullFloatValidator(String? value) {
    value = value?.toLowerCase().trim();
    if (value == null || value.isEmpty) return 'Field cannot be empty!';
    if (!isFloat(value)) return 'Must be a number!';
    return null;
  }

  static String? emailValidator(String? value) {
    if (value?.isEmpty ?? true) return 'Email is required!';

    return isEmail(value!) ? null : 'Invalid email!';
  }
}
