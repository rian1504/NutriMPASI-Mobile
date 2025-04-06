// BASE URL
// Jika menggunakan android device (AVD)
// String url = 'http://10.0.0.2:8000/api/';

// Jika menggunakan hp android (USB Debugging)
// php artisan serve --host=0.0.0.0 --port=8000
// ambil ipv4 untuk baseUrl

String baseUrl = 'http://127.0.0.1:8000/';
// String baseUrl = 'http://192.168.1.11:8000/';
// String baseUrl = 'https://nutrimpasi.site/';
String apiUrl = '${baseUrl}api/';
String storageUrl = '${baseUrl}storage/';
var headers = {'Accept': 'application/json'};

// API ENDPOINTS
class ApiEndpoints {
  static const String register = 'register';
  static const String login = 'login';
  static const String logout = 'logout';
  static const String forgotPassword = 'forgot-password';
  static const String resetPassword = 'reset-password';
}
