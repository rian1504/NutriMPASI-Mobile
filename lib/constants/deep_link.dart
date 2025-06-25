import 'package:flutter/material.dart';
import 'package:nutrimpasi/screens/auth/reset_password_screen.dart';
import 'package:app_links/app_links.dart';
import 'package:nutrimpasi/main.dart';

class DeepLinkHandler {
  static final AppLinks _appLinks = AppLinks();

  static Future<void> initDeepLinking() async {
    try {

      // Handle cold start (app launched from terminated state)
      final initialUri = await _appLinks.getInitialLink();
      if (initialUri != null) {
        debugPrint('Initial deep link detected: $initialUri');
        _handleDeepLink(initialUri);
      }

      // Handle when app is in foreground/background
      _appLinks.uriLinkStream.listen(
        (Uri? uri) {
          if (uri != null) {
            debugPrint('Deep link stream received: $uri');
            _handleDeepLink(uri);
          }
        },
        onError: (error) {
          debugPrint('Deep link stream error: $error');
        },
      );
    } catch (e) {
      debugPrint('Deep link initialization error: $e');
    }
  }

  static void _handleDeepLink(Uri uri) {
    try {
      debugPrint('Handling deep link: ${uri.toString()}');

      // Handle password reset links
      // Check if the path starts with /password-reset
      if (uri.path.startsWith('/password-reset')) {
        // Further check if it matches the expected structure /password-reset/<token>
        // by checking if there are enough path segments.
        if (uri.pathSegments.length >= 2 &&
            uri.pathSegments[0] == 'password-reset') {
          _handlePasswordResetLink(uri);
        } else {
          debugPrint(
            'Deep link path starts with /password-reset but does not match expected format /password-reset/<token>',
          );
        }
      }
      // Add other deep link handlers here as needed
      // else if (uri.path.startsWith('/other-path')) {
      //   _handleOtherDeepLink(uri);
      // }
    } catch (e) {
      debugPrint('Error handling deep link: $e');
    }
  }

  static void _handlePasswordResetLink(Uri uri) {
    try {
      // Check if there are enough segments before accessing index 1
      String? token;
      if (uri.pathSegments.length > 1) {
        token = uri.pathSegments[1]; // Get the segment after '/password-reset/'
      }

      // Extract email from query parameters
      final email = uri.queryParameters['email'];

      debugPrint(
        'Attempting to handle reset link: token=$token (from path segment 1), email=$email (from query)',
      );

      if (token == null || token.isEmpty || email == null || email.isEmpty) {
        debugPrint(
          'Invalid reset password link - missing token (expected in path) or email (expected in query)',
        );
        // Optionally show an error to the user using navigatorKey.currentState?.showSnackBar(...)
        return;
      }

      // Verify token format if needed
      // if (!_isValidToken(token)) {...}

      debugPrint(
        'Navigating to reset password screen with token=$token, email=$email',
      );

      // Ensure the navigator is ready and push the replacement route
      if (navigatorKey.currentState != null) {
        // Use pushReplacement to replace the current screen (e.g., splash, home, etc.)
        navigatorKey.currentState!.pushReplacement(
          MaterialPageRoute(
            builder:
                (context) => ResetPasswordScreen(token: token!, email: email),
          ),
        );
      } else {
        debugPrint('Navigator state is not available to push route');
      }
    } catch (e) {
      debugPrint('Error handling password reset link: $e');
    }
  }
}
