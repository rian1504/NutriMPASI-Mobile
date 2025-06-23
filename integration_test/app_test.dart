import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:nutrimpasi/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('End-to-end tests', () {
    testWidgets('Verify login flow up to home screen', (tester) async {
      try {
        // Print visibility for debugging
        debugPrint('Starting login test...');

        // Start the app
        app.main();
        await tester.pumpAndSettle();
        debugPrint('App started');

        // Wait for splash screen with timeout
        int splashAttempts = 0;
        while (splashAttempts < 10) {
          await tester.pump(const Duration(seconds: 1));
          debugPrint(
            'Waiting for splash screen to finish... attempt: ${splashAttempts + 1}',
          );
          splashAttempts++;

          // Check if we see onboarding elements
          if (find.text('Jadwal').evaluate().isNotEmpty &&
              find.text('Memasak').evaluate().isNotEmpty) {
            debugPrint('Onboarding screen found');
            break;
          }
        }

        // Verify we're on the onboarding screen
        expect(find.text('Jadwal'), findsOneWidget);
        expect(find.text('Memasak'), findsOneWidget);
        debugPrint('Found onboarding elements');

        // Find and tap the "Lewati" button
        final skipButton = find.text('Lewati');
        expect(skipButton, findsOneWidget);
        debugPrint('Found skip button');
        await tester.tap(skipButton);
        await tester.pumpAndSettle();
        debugPrint('Tapped skip button');

        // Verify we're on the login screen
        expect(find.text('Masuk'), findsWidgets);
        expect(find.text('Daftar'), findsOneWidget);
        debugPrint('Found login elements');

        // Enter email and password
        final emailField = find.widgetWithText(TextFormField, 'Email');
        final passwordField = find.widgetWithText(TextFormField, 'Kata Sandi');

        expect(emailField, findsOneWidget);
        expect(passwordField, findsOneWidget);

        await tester.enterText(emailField, 'leant@gmail.com');
        await tester.enterText(passwordField, 'leant123');
        debugPrint('Entered credentials');

        // Submit login form
        final loginButton = find.widgetWithText(ElevatedButton, 'Masuk').last;
        expect(loginButton, findsOneWidget);
        await tester.tap(loginButton);
        debugPrint('Tapped login button');

        // Wait for login process to complete
        await tester.pump(); // Process the tap
        debugPrint('Waiting for login response...');

        // Wait for welcome message with timeout
        bool foundWelcome = false;
        int loginAttempts = 0;
        while (loginAttempts < 15 && !foundWelcome) {
          await tester.pump(const Duration(seconds: 1));
          debugPrint(
            'Waiting for welcome message... attempt: ${loginAttempts + 1}',
          );
          loginAttempts++;

          // Check for welcome message
          foundWelcome =
              find.text('Selamat datang mama!').evaluate().isNotEmpty;
          if (foundWelcome) {
            debugPrint('Found welcome message');
            break;
          }
        }

        // Verify welcome message appeared
        expect(find.text('Selamat datang mama!'), findsOneWidget);

        // Wait for home screen to load
        debugPrint('Waiting for home screen to load...');

        int homeScreenAttempts = 0;
        bool foundHomeScreen = false;

        while (homeScreenAttempts < 20 && !foundHomeScreen) {
          await tester.pump(const Duration(seconds: 1));
          debugPrint(
            'Waiting for home screen... attempt: ${homeScreenAttempts + 1}',
          );
          homeScreenAttempts++;

          // Check for home screen element
          foundHomeScreen = find.text('Halo, Moms').evaluate().isNotEmpty;
          if (foundHomeScreen) {
            debugPrint('Found home screen');
            break;
          }
        }

        // Verify we're on the home screen
        await tester.pump();
        expect(find.text('Halo, Moms'), findsWidgets);
        debugPrint('Successfully navigated to home screen');
        await tester.pump();

        // Test stops here - we don't proceed to the schedule screen

        // Print success message
        debugPrint(
          '✅ Test completed successfully: Login and reaching home screen verified',
        );
      } catch (e, stackTrace) {
        debugPrint('TEST FAILED WITH ERROR: $e');
        debugPrint('STACK TRACE: $stackTrace');
        rethrow;
      }
    });

    // New test case for navigating to Features Screen and then Cooking History
    testWidgets('Navigate to Cooking History via Features Screen', (
      tester,
    ) async {
      try {
        debugPrint(
          'Starting navigation test to Cooking History via Features Screen...',
        );

        // Start the app
        app.main();
        await tester.pumpAndSettle();
        debugPrint('App started');

        // Wait for splash screen with timeout
        int splashAttempts = 0;
        while (splashAttempts < 10) {
          await tester.pump(const Duration(seconds: 1));
          debugPrint(
            'Waiting for splash screen to finish... attempt: ${splashAttempts + 1}',
          );
          splashAttempts++;

          // Check if we see onboarding elements
          if (find.text('Halo, Moms').evaluate().isNotEmpty) {
            debugPrint('Home screen found');
            break;
          }
        }

        expect(find.text('Halo, Moms'), findsWidgets);
        debugPrint('Successfully reached home screen');

        // Give time for the screen to fully render
        await tester.pump();

        // Find and tap the "Fitur Lainnya" section using ValueKey
        final featuresSectionFinder = find.byKey(
          const ValueKey('features_section'),
        );
        expect(
          featuresSectionFinder,
          findsOneWidget,
          reason: 'Could not find features_section widget',
        );
        debugPrint('Found features section with key');

        await tester.tap(featuresSectionFinder);
        await tester.pump();
        debugPrint('Tapped on features section');

        // Verify we're on the Features Screen
        await tester.pump();
        expect(find.text('Fitur Lainnya'), findsWidgets);
        debugPrint('Successfully navigated to Features Screen');

        // Find and tap on the Cooking History card
        await tester.pump(Duration(seconds: 3));
        final cookingHistoryCard = find.text('Riwayat Memasak');
        expect(cookingHistoryCard, findsOneWidget);
        debugPrint('Found cooking history card');

        await tester.tap(cookingHistoryCard);
        await tester.pump();
        debugPrint('Tapped cooking history card');

        // Verify we're on the Cooking History screen
        await tester.pump();
        expect(find.text('Riwayat Memasak'), findsWidgets);
        debugPrint('Successfully navigated to Cooking History screen');
        await tester.pumpAndSettle(Duration(seconds: 2));

        debugPrint(
          '✅ Navigation to Cooking History via Features Screen test passed successfully',
        );
      } catch (e, stackTrace) {
        debugPrint('TEST FAILED WITH ERROR: $e');
        debugPrint('STACK TRACE: $stackTrace');
        rethrow;
      }
    });
  });
}
