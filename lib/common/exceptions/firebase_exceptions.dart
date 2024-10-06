enum FirebaseException implements Exception {
  invalidEmail,
  userDisabled,
  userNotLoggedIn,
  userNotFound,
  wrongPassword,
  genericExceptions,
  emailAlreadyInUse,
  weakPassword,
}

FirebaseException firebaseExceptionReturner(String? statusCode) =>
    switch (statusCode) {
      'invalid-email' => FirebaseException.invalidEmail,
      'user-disabled' => FirebaseException.userDisabled,
      'user-not-found' => FirebaseException.userNotFound,
      'wrong-password' => FirebaseException.wrongPassword,
      'email-already-in-use' => FirebaseException.emailAlreadyInUse,
      'weak-password' => FirebaseException.weakPassword,
      'user-not-logged-in' => FirebaseException.userNotLoggedIn,
      null => FirebaseException.genericExceptions,
      String() => FirebaseException.genericExceptions,
    };

final Map<FirebaseException, String> exceptionTextReturner = {
  FirebaseException.invalidEmail: 'invalid-email',
  FirebaseException.userDisabled: 'user-disabled',
  FirebaseException.userNotFound: 'user-not-found',
  FirebaseException.wrongPassword: 'wrong-password',
  FirebaseException.emailAlreadyInUse: 'email-already-in-use',
  FirebaseException.weakPassword: 'weak-password',
  FirebaseException.userNotLoggedIn: 'user-not-logged-in',
};
