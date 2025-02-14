class ApiEndPoint {
  static String get _baseUrl => "";
  static String get loginApi => "$_baseUrl/backend/public/api/login";
  static String get logOut => "$_baseUrl/backend/public/api/logout";
  static String get products => "$_baseUrl/backend/public/api/fg-with-stock";
}
