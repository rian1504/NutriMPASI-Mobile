// BASE URL
// server lokal dengan debug ke windows/web browser
String baseUrl = 'http://127.0.0.1:8000/';

// universal menggunakan API dari server
// String baseUrl = 'https://nutrimpasi.site/';

// jika menggunakan API lokal dan device emulator android (AVD)
// String baseUrl = 'http://10.0.2.2:8000/';

// jika menggunakan API lokal dan device android (USB Debugging)
// jalankan server lokal dengan command berikut
// php artisan serve --host=0.0.0.0 --port=8000
// baseUrl bisa diketahui dengan menjalankan perintah 'ipconfig' di terminal mengambil ipv4
// String baseUrl = 'http://192.168.x.x:8000/';

String apiUrl = '${baseUrl}api/';
String storageUrl = '${baseUrl}storage/';
var headers = {'Accept': 'application/json'};

// API ENDPOINTS
class ApiEndpoints {
  // Authentication
  static const String register = 'register';
  static const String login = 'login';
  static const String logout = 'logout';
  static const String user = 'user';
  static const String forgotPassword = 'forgot-password';
  static const String resetPassword = 'reset-password';
  static const String profile = 'profile';

  // Baby
  static const String baby = 'baby';
  static const String babyFoodRecommendation = '$baby/food-recommendation';

  // Food
  static const String food = 'food';
  static const String foodCategory = '$food/category';
  static const String foodFilter = '$food/filter';
  static const String foodRecord = '$food/record';

  // Favorite
  static const String favorite = 'favorite';

  // Schedule
  static const String schedule = 'schedule';

  // Nutritionist
  static const String nutritionist = 'nutritionist';

  // Food Suggestion
  static const String foodSuggestion = 'food-suggestion';

  // Notification
  static const String notification = 'notification';

  // Report
  static const String report = 'report';

  // Thread
  static const String thread = 'thread';
  static const String threadUser = 'thread-user';

  // Comment
  static const String comment = 'comment';

  // Like
  static const String like = 'like';
}
