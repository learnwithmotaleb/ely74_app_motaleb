enum AuthProcess {
  signUp,
  login,
  logout,
  activateAccount,
  forgetPassword,
  resetPassword,
  verifyOtp,
  packageGet,
  none,
}

enum Status {
  archived, // Lowercase for consistency with Dart naming conventions
  active,
  sold,
  pending,
  rejected;

  // Optional: Add a method to get the capitalized string representation
  String get capitalized => name[0].toUpperCase() + name.substring(1);

  // Optional: Add a method to get the uppercase string (like your original)
  String get uppercase => name.toUpperCase();
}
