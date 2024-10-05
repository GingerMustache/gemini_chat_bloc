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
      'user-not-logged-in' => FirebaseException.weakPassword,
      null => FirebaseException.genericExceptions,
      String() => FirebaseException.genericExceptions,
    };
