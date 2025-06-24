import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:nutrimpasi/constants/colors.dart';
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

        // Close the keyboard by tapping outside the text field
        await tester.pump();
        await tester.tap(find.byType(Scaffold), warnIfMissed: false);
        debugPrint('Closed keyboard');
        await tester.pumpAndSettle();

        // Submit login form
        final loginButton = find.widgetWithText(ElevatedButton, 'Masuk').last;
        expect(loginButton, findsOneWidget);
        await tester.tap(loginButton);
        debugPrint('Tapped login button');

        // Wait for login process to complete
        await tester.pump();
        debugPrint('Waiting for login response...');

        // Wait for welcome message with timeout
        bool foundWelcome = false;
        int loginAttempts = 0;
        while (loginAttempts < 15 && !foundWelcome) {
          await tester.pump(const Duration(milliseconds: 200));
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

        // Wait for home screen with timeout
        int homeScreen = 0;
        while (homeScreen < 10) {
          await tester.pump(const Duration(seconds: 1));
          debugPrint(
            'Waiting for home screen to finish... attempt: ${homeScreen + 1}',
          );
          homeScreen++;

          // Check if we see onboarding elements
          if (find.text('Halo, Moms').evaluate().isNotEmpty) {
            debugPrint('home screen finish');
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

          // Check if we see home screen elements
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
        await tester.pump(Duration(seconds: 2));
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
        await tester.pump();

        // Wait for nutrition indicator with timeout
        int nutritionIndicator = 0;
        while (nutritionIndicator < 10) {
          await tester.pump(const Duration(seconds: 1));
          debugPrint(
            'Waiting for nutrition indicator to finish... attempt: ${nutritionIndicator + 1}',
          );
          nutritionIndicator++;

          // Check if we see onboarding elements
          if (find.text('913').evaluate().isNotEmpty) {
            debugPrint('Nutrition Indicator finish');
            break;
          }
        }
        await tester.pump(Duration(seconds: 3));

        debugPrint(
          '✅ Navigation to Cooking History via Features Screen test passed successfully',
        );
      } catch (e, stackTrace) {
        debugPrint('TEST FAILED WITH ERROR: $e');
        debugPrint('STACK TRACE: $stackTrace');
        rethrow;
      }
    });

    testWidgets('Navigate to Food List and add food suggestion', (
      tester,
    ) async {
      try {
        debugPrint('Starting food suggestion flow test...');

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

          // Check if we see home screen elements
          if (find.text('Halo, Moms').evaluate().isNotEmpty) {
            debugPrint('Home screen found');
            break;
          }
        }

        expect(find.text('Halo, Moms'), findsWidgets);
        debugPrint('Successfully reached home screen');

        // Give time for the screen to fully render
        await tester.pump();

        // Tap the food list tab in the bottom navigation bar (usually index 1)
        debugPrint('Attempting to tap food list tab in bottom nav bar...');

        // Get the screen size to tap at the expected position
        final screenSize = tester.getSize(find.byType(MaterialApp));

        // Try tapping at the position where the second tab would be (20% from the left)
        await tester.tapAt(
          Offset(screenSize.width * 0.2, screenSize.height - 30),
        );
        await tester.pumpAndSettle();
        debugPrint(
          'Tapped at position: ${screenSize.width * 0.2}, ${screenSize.height - 30}',
        );

        // Check if we've navigated to the food list screen
        await tester.pump(const Duration(seconds: 1));
        expect(find.text('Masak apa hari ini?'), findsOneWidget);
        debugPrint('Successfully navigated to food list screen');

        // Toggle to "Usulan Saya" tab
        await tester.pump(const Duration(seconds: 1));
        debugPrint('Attempting to toggle to Usulan Saya...');

        // The toggle is on the right side of the screen
        final rightToggle = find.text('Usulan Saya');
        await tester.pump(Duration(seconds: 1));
        expect(rightToggle, findsOneWidget);
        await tester.pump(Duration(seconds: 1));
        await tester.tap(rightToggle, warnIfMissed: false);
        await tester.pumpAndSettle();

        debugPrint('Toggled to Usulan Saya view');

        // Tap the add suggestion button (usually a floating button or banner with "Tambahkan Usulan")
        debugPrint('Looking for add suggestion button...');

        // First check if there's a "Tambah Usulan" button visible
        final addButton = find.text('Tambahkan Foto');

        if (addButton.evaluate().isNotEmpty) {
          await tester.tap(addButton);
          debugPrint('Tapped the "Tambahkan Foto" button');
        } else {
          // Try finding any button with "Tambah" text
          final anyAddButton = find.textContaining('Tambah');

          if (anyAddButton.evaluate().isNotEmpty) {
            await tester.tap(anyAddButton.first);
            debugPrint('Tapped button containing "Tambah" text');
          } else {
            // Try tapping the banner directly
            final bannerArea = Offset(screenSize.width / 2, 180);
            await tester.tapAt(bannerArea);
            debugPrint('Tapped at center of banner area: $bannerArea');
          }
        }

        await tester.pumpAndSettle();

        // Check if we've navigated to the food add suggestion screen
        expect(find.text('Tambahkan Usulan Makanan'), findsOneWidget);
        debugPrint('Successfully navigated to add food suggestion screen');

        // Fill out the form fields using the ValueKeys found in food_add_suggestion_screen.dart
        debugPrint('Filling out food suggestion form using keys...');

        // Find the main form ListView to use for scrolling
        final formListView = find.byType(ListView).first;

        // Recipe name field using ValueKey('_recipeNameKey')
        final recipeNameField = find.byKey(const ValueKey('_recipeNameKey'));
        expect(
          recipeNameField,
          findsOneWidget,
          reason: 'Recipe name field not found',
        );
        await tester.enterText(recipeNameField, 'Bubur Bayam Wortel');
        debugPrint('Entered recipe name');

        // For the photo - instead of trying to pick an image which doesn't work in tests,
        // we'll mock a successful image selection by directly calling the function that
        // would handle a selected image
        // Find and tap the mock image button if it exists
        final mockImageButton = find.text('USE_TEST_IMAGE');
        if (mockImageButton.evaluate().isNotEmpty) {
          await tester.tap(mockImageButton);
          debugPrint('Used test image for photo');
        } else {
          debugPrint('Test image button not found - skipping photo selection');
          // Just continue with the test - photo validation will be handled by the app
        }

        // Category dropdown using ValueKey('_categoryKey')
        final categoryField = find.byKey(const ValueKey('_categoryKey'));
        expect(
          categoryField,
          findsOneWidget,
          reason: 'Category field not found',
        );
        await tester.tap(categoryField);
        await tester.pumpAndSettle();
        // Select the first option in the dropdown
        final categoryOption = find.text('Sarapan').first;
        await tester.tap(categoryOption);
        await tester.pumpAndSettle();
        debugPrint('Selected category');

        // Age group dropdown using ValueKey('_ageKey')
        final ageField = find.byKey(const ValueKey('_ageKey'));
        expect(ageField, findsOneWidget, reason: 'Age field not found');
        await tester.tap(ageField);
        await tester.pumpAndSettle();
        // Select the first option in the dropdown
        final ageOption = find.text('6-8').first;
        await tester.tap(ageOption);
        await tester.pumpAndSettle();
        debugPrint('Selected age group');

        // Portion field using ValueKey('_portionKey')
        final portionField = find.byKey(const ValueKey('_portionKey'));
        expect(portionField, findsOneWidget, reason: 'Portion field not found');
        await tester.enterText(portionField, '2');
        debugPrint('Entered portion');

        // Scroll down significantly to reveal more fields
        // This is the critical part - scroll enough to make description field visible
        debugPrint('Scrolling down to reveal description field...');
        await tester.drag(formListView, const Offset(0, -500));
        await tester.pumpAndSettle();

        // Wait a moment after scrolling
        await tester.pump(const Duration(milliseconds: 500));

        // Try to find the description field now that we've scrolled
        final descriptionField = find.byKey(const ValueKey('_descriptionKey'));
        expect(
          descriptionField,
          findsOneWidget,
          reason: 'Description field not found after scrolling',
        );
        await tester.enterText(
          descriptionField,
          'Bubur sehat untuk bayi 6 bulan dengan bayam dan wortel',
        );
        debugPrint('Entered description');

        // Scroll down more to reveal ingredient fields
        debugPrint('Scrolling down to reveal ingredient fields...');
        await tester.drag(formListView, const Offset(0, -400));
        await tester.pumpAndSettle();
        await tester.pump(const Duration(milliseconds: 500));

        // Find ingredient field by looking for the Bahan 1 hint text
        final ingredientField = find.widgetWithText(TextFormField, 'Bahan 1');
        expect(
          ingredientField,
          findsOneWidget,
          reason: 'First ingredient field not found',
        );
        await tester.enterText(ingredientField, '1 sdm Beras');
        debugPrint('Entered first ingredient');

        // Add another ingredient
        final addIngredientButton = find.text('Tambah Bahan');
        expect(
          addIngredientButton,
          findsOneWidget,
          reason: 'Add ingredient button not found',
        );
        await tester.tap(addIngredientButton);
        await tester.pumpAndSettle();

        // Enter the second ingredient - find by Bahan 2 hint text
        final ingredientField2 = find.widgetWithText(TextFormField, 'Bahan 2');
        expect(
          ingredientField2,
          findsOneWidget,
          reason: 'Second ingredient field not found',
        );
        await tester.enterText(ingredientField2, '50g Bayam');
        debugPrint('Entered second ingredient');

        // Scroll down more to reveal step fields
        debugPrint('Scrolling down to reveal step fields...');
        await tester.drag(formListView, const Offset(0, -400));
        await tester.pumpAndSettle();
        await tester.pump(const Duration(milliseconds: 500));

        // Find step field by looking for the Langkah 1 hint text
        final stepField = find.widgetWithText(TextFormField, 'Langkah 1');
        expect(stepField, findsOneWidget, reason: 'First step field not found');
        await tester.enterText(stepField, 'Cuci beras dan masak dengan air');
        debugPrint('Entered first step');

        // Make sure we're scrolled all the way to the bottom to see the next button
        debugPrint('Scrolling to ensure next button is visible...');
        await tester.drag(formListView, const Offset(0, -1000));
        await tester.pumpAndSettle();

        // Look for the next button (orange circle at bottom right)
        debugPrint('Looking for the next button...');

        // Wait a moment to ensure UI is stable
        await tester.pump(const Duration(seconds: 1));

        // Try different approaches to find and tap the next button
        bool nextButtonTapped = false;

        // First try: Find using the arrow icon
        final nextButtonIcon = find.byIcon(Icons.arrow_right_alt_rounded);
        if (nextButtonIcon.evaluate().isNotEmpty) {
          await tester.tap(nextButtonIcon);
          nextButtonTapped = true;
          debugPrint('Tapped next button by icon');
        }

        // Second try: Look for the accent-colored circle
        if (!nextButtonTapped) {
          final accentColorButton = find.byWidgetPredicate((widget) {
            return widget is Container &&
                widget.decoration is BoxDecoration &&
                (widget.decoration as BoxDecoration).color ==
                    AppColors.accent &&
                (widget.decoration as BoxDecoration).shape == BoxShape.circle;
          });

          if (accentColorButton.evaluate().isNotEmpty) {
            await tester.tap(accentColorButton);
            nextButtonTapped = true;
            debugPrint('Tapped next button by accent color');
          }
        }

        // Third try: Find and tap the GestureDetector at the bottom right
        if (!nextButtonTapped) {
          final gestureDetector = find.descendant(
            of: find.byWidgetPredicate(
              (widget) =>
                  widget is Positioned &&
                  widget.right != null &&
                  widget.right! < 0 &&
                  widget.bottom != null &&
                  widget.bottom! < 0,
            ),
            matching: find.byType(GestureDetector),
          );

          if (gestureDetector.evaluate().isNotEmpty) {
            await tester.tap(gestureDetector);
            nextButtonTapped = true;
            debugPrint('Tapped next button by gesture detector');
          }
        }

        // Last resort: Tap at position
        if (!nextButtonTapped) {
          await tester.tapAt(
            Offset(screenSize.width - 50, screenSize.height - 50),
          );
          debugPrint('Tapped next button at position (last resort)');
        }

        // Wait patiently for the navigation to complete
        debugPrint('Waiting for navigation after next button tap...');
        await tester.pumpAndSettle(const Duration(seconds: 2));

        // Additional pump to ensure UI updates
        await tester.pump(const Duration(seconds: 1));

        // Check if we've navigated to the nutrition calculator screen
        // Make sure we retry a few times as the navigation might take time
        int attempts = 0;
        bool foundCalculator = false;
        while (attempts < 5 && !foundCalculator) {
          await tester.pump(const Duration(milliseconds: 500));
          foundCalculator = find.text('Kalkulator Gizi').evaluate().isNotEmpty;
          attempts++;
        }

        expect(
          find.text('Kalkulator Gizi'),
          findsWidgets,
          reason: 'Did not navigate to nutrition calculator screen',
        );
        debugPrint('Successfully navigated to nutrition calculator screen');

        // Wait for calculation to complete (look for "Hasil Perhitungan Nutrisi:")
        debugPrint('Waiting for nutrition calculation to complete...');
        await tester.pump();
        int calculationWaitCounter = 0;
        bool calculationComplete = false;

        while (calculationWaitCounter < 20 && !calculationComplete) {
          await tester.pump(const Duration(seconds: 1));
          calculationWaitCounter++;
          debugPrint(
            'Waiting for nutrition calculation... attempt $calculationWaitCounter',
          );

          // Check if calculation is complete by looking for numeric values
          calculationComplete =
              find.textContaining('kkal').evaluate().isNotEmpty;

          if (calculationComplete) {
            debugPrint('Nutrition calculation completed');
            break;
          }
        }

        // Ensure calculation completed
        expect(find.textContaining('kkal'), findsOneWidget);

        // Tap the save button
        debugPrint('Tapping save button...');
        await tester.tap(find.text('Simpan'));
        await tester.pumpAndSettle(const Duration(seconds: 3));

        // Wait for success message
        debugPrint('Waiting for success message to complete...');
        await tester.pump();
        int successMessageWaitCounter = 0;
        bool successMessageComplete = false;

        while (successMessageWaitCounter < 20 && !successMessageComplete) {
          await tester.pump(const Duration(seconds: 1));
          successMessageWaitCounter++;
          debugPrint(
            'Waiting for success message... attempt $successMessageWaitCounter',
          );

          // Check if calculation is complete by looking for numeric values
          successMessageComplete =
              find.textContaining('Usulan Saya').evaluate().isNotEmpty;

          if (successMessageComplete) {
            debugPrint('Success message completed');
            break;
          }
        }

        debugPrint('✅ Food suggestion flow test completed successfully');
      } catch (e, stackTrace) {
        debugPrint('TEST FAILED WITH ERROR: $e');
        debugPrint('STACK TRACE: $stackTrace');
        rethrow;
      }
    });

    
  });
}
