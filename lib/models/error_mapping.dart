import '../enums/error_types.dart';

class ExceptionMapping {
  static const Map<String, ErrorType> signInExceptionMapper = {
    'invalid-email': ErrorType.EmailError,
    'wrong-password': ErrorType.PasswordError,
    'user-disabled': ErrorType.RequestError,
    //signup should be visible after this error
    'user-not-found': ErrorType.RequestError,
  };

  static const Map<String, ErrorType> signUpExceptionMapper = {
    'email-already-in-use': ErrorType.EmailError,
    'invalid-email': ErrorType.EmailError,
    'operation-not-allowed': ErrorType.RequestError,
    //should be validated either using the form controller or after signing up
    'weak-password': ErrorType.PasswordError,
  };

  static const Map<ErrorType, String> exceptionErrorMessages = {
    ErrorType.EmailError: 'Please check or try another email adress',
    ErrorType.PasswordError: 'Please check and Re-enter the password',
    ErrorType.RequestError:
        'Make sure that the email and password are associated with an Account',
  };
}
