import '../extensions/string_validation_extension.dart';

//saw an iteration of using provider and a validation class since it's a request and
//not an on save function then it shouldnt belong to a form provider
class Validators {
  static String? validateEmail(String? val) {
    if (val == null || !val.isValidEmail) {
      return 'Please Enter a Valid Email Address';
    }
    return null;
  }

  static String? validateName(String? val) {
    if (val == null || !val.isValidName) {
      return 'Please Enter a Valid Name';
    }
    return null;
  }

  static String? validatePassword(String? val) {
    if (val == null || !val.isValidPassword) {
      return 'Please Enter a Valid Password Containing capital and small letters with special signs';
    }
    return null;
  }

  static String? validatePhone(String? val) {
    if (val == null || !val.isValidPhone) {
      return 'Please Enter a Valid phone number';
    }
    return null;
  }
}

//probably in upgrading will add an error provider extending these functions and ovverriding for an OnSaving module
//or an error providers for checking onsave using the request erros but it's an overkill and should be solved on it own another time 8/10/2023
