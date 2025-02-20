import 'package:flutter/material.dart';

class FirebaseErrorValidation {
  const FirebaseErrorValidation._();

  /// default messages for firebase auth exceptions
  static const Map<String, String> _kErrorMessages = {
    'unknown': 'An unknown exception occurred.',
    'invalid-email': 'Email is not valid or badly formatted.',
    'user-disabled':
        'This user has been disabled. Please contact support for help.',
    'email-already-in-use': 'An account already exists for that email.',
    'operation-not-allowed':
        'Operation is not allowed.  Please contact support.',
    'weak-password': 'Please enter a stronger password.',
    'user-not-found': 'Email is not found, please create an account.',
    'wrong-password': 'Incorrect password, please try again.',
    'account-exists-with-different-credential':
        'Account exists with different credentials.',
    'invalid-credential':
        'Invalid email or password. Check yor data and try again',
    'invalid-verification-code':
        'The credential verification code received is invalid.',
    'invalid-verification-id':
        'The credential verification ID received is invalid.',
    'expired-action-code': 'Link is expired, request a new one',
    'invalid-action-code': 'Your link is invalid, request a new one.',
  };

  static String getErrorMessageFromCode(String code) {
    const unknownException = 'Sorry, an error occurred';
    if (code.isEmpty || !_kErrorMessages.containsKey(code)) {
      debugPrint('FirebaseErrorValidation: Error code is empty');
      return unknownException;
    }

    return _kErrorMessages[code] ?? unknownException;
  }
}
