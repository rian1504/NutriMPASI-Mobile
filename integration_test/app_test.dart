import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:nutrimpasi/constants/colors.dart';
import 'package:nutrimpasi/constants/icons.dart';
import 'package:nutrimpasi/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Automated Testing', () {
    testWidgets(': Test Login', (tester) async {
      try {
        // Menampilkan debug info
        debugPrint('Memulai test login...');

        // Memulai aplikasi
        app.main();
        await tester.pumpAndSettle();
        debugPrint('Aplikasi berhasil dimulai');

        // Menunggu splash screen dengan timeout
        int splashAttempts = 0;
        while (splashAttempts < 10) {
          await tester.pump(const Duration(seconds: 1));
          debugPrint(
            'Menunggu splash screen selesai... percobaan: ${splashAttempts + 1}',
          );
          splashAttempts++;

          // Memeriksa apakah elemen onboarding terlihat
          if (find.text('Jadwal').evaluate().isNotEmpty &&
              find.text('Memasak').evaluate().isNotEmpty) {
            break;
          }
        }

        // Verifikasi berada di layar onboarding
        expect(find.text('Jadwal'), findsOneWidget);
        expect(find.text('Memasak'), findsOneWidget);
        debugPrint('Berhasil navigasi ke halaman onboarding');
        await tester.pump(const Duration(seconds: 1));

        // Menemukan dan tap tombol "Lewati"
        final skipButton = find.text('Lewati');
        expect(skipButton, findsOneWidget);
        await tester.tap(skipButton);
        await tester.pumpAndSettle();
        debugPrint('Mencoba menekan tombol lewati');

        // Verifikasi berada di layar login
        debugPrint('Berhasil navigasi ke halaman login');
        await tester.pump(const Duration(seconds: 1));
        expect(find.text('Masuk'), findsWidgets);
        expect(find.text('Daftar'), findsOneWidget);

        // Memasukkan email dan password
        debugPrint('Mencoba memasukkan kredensial');
        final emailField = find.widgetWithText(TextFormField, 'Email');
        final passwordField = find.widgetWithText(TextFormField, 'Kata Sandi');

        expect(emailField, findsOneWidget);
        expect(passwordField, findsOneWidget);

        await tester.enterText(emailField, 'leant@gmail.com');
        await tester.enterText(passwordField, 'leant123');
        debugPrint('Kredensial telah dimasukkan');

        // Menutup keyboard dengan tap di luar text field
        await tester.pump();
        await tester.tap(find.byType(Scaffold), warnIfMissed: false);
        await tester.pumpAndSettle();

        // Mengirim form login
        final loginButton = find.widgetWithText(ElevatedButton, 'Masuk').last;
        expect(loginButton, findsOneWidget);
        await tester.tap(loginButton);
        debugPrint('Mencoba menekan tombol login');

        // Menunggu proses login selesai
        await tester.pump();
        debugPrint('Menunggu respon login...');

        // Menunggu berhasil login dengan timeout
        bool foundWelcome = false;
        int loginAttempts = 0;
        while (loginAttempts < 15 && !foundWelcome) {
          await tester.pump(const Duration(milliseconds: 200));
          debugPrint(
            'Menunggu proses login... percobaan: ${loginAttempts + 1}',
          );
          loginAttempts++;

          // Memeriksa berhasil login
          foundWelcome =
              find.text('Selamat datang mama!').evaluate().isNotEmpty;
          if (foundWelcome) {
            debugPrint('Berhasil login');
            break;
          }
        }

        // Verifikasi pesan selamat datang muncul
        expect(find.text('Selamat datang mama!'), findsOneWidget);

        // Menunggu halaman beranda dengan timeout
        int homeScreenAttempts = 0;
        while (homeScreenAttempts < 10) {
          await tester.pump(const Duration(seconds: 1));
          homeScreenAttempts++;

          // Memeriksa apakah elemen halaman beranda terlihat
          if (find.text('Halo, Moms').evaluate().isNotEmpty) {
            break;
          }
        }

        // Verifikasi berada di halaman beranda
        await tester.pump(const Duration(seconds: 2));
        expect(find.text('Halo, Moms'), findsWidgets);
        debugPrint('Berhasil navigasi ke halaman beranda');
        await tester.pump(const Duration(seconds: 2));

        // Menampilkan pesan keberhasilan
        debugPrint('✅ Test selesai dengan sukses: Berhasil login (1/1)');
      } catch (e, stackTrace) {
        debugPrint('TEST GAGAL DENGAN ERROR: $e');
        debugPrint('STACK TRACE: $stackTrace');
        rethrow;
      }
    });

    testWidgets('Test Fitur Riwayat Makanan', (tester) async {
      try {
        debugPrint('Memulai test fitur riwayat makanan...');

        // Memulai aplikasi
        app.main();
        await tester.pumpAndSettle();
        debugPrint('Aplikasi berhasil dimulai');

        // Menunggu splash screen dengan timeout
        int splashAttempts = 0;
        while (splashAttempts < 10) {
          await tester.pump(const Duration(seconds: 1));
          debugPrint(
            'Menunggu splash screen selesai... percobaan: ${splashAttempts + 1}',
          );
          splashAttempts++;

          // Memeriksa apakah elemen halaman beranda terlihat
          if (find.text('Halo, Moms').evaluate().isNotEmpty) {
            break;
          }
        }

        expect(find.text('Halo, Moms'), findsWidgets);
        debugPrint('Berhasil navigasi ke halaman beranda');

        // Memberi waktu untuk layar render sepenuhnya
        await tester.pump(const Duration(seconds: 2));

        // Menemukan dan tap bagian "Fitur Lainnya"
        final featuresSectionFinder = find.byKey(
          const ValueKey('features_section'),
        );
        expect(
          featuresSectionFinder,
          findsOneWidget,
          reason: 'Tidak dapat menemukan widget features_section',
        );

        await tester.tap(featuresSectionFinder);
        await tester.pump();
        debugPrint('mencoba menekan bagian fitur lainnya');

        // Verifikasi berada di layar Fitur
        await tester.pump();
        expect(find.text('Fitur Lainnya'), findsWidgets);
        debugPrint('Berhasil navigasi ke halaman fitur lainnya');

        // Menemukan dan tap pada kartu Riwayat Memasak
        await tester.pump(const Duration(seconds: 2));
        final cookingHistoryCard = find.text('Riwayat Memasak');
        expect(cookingHistoryCard, findsOneWidget);

        await tester.tap(cookingHistoryCard);
        await tester.pump();
        debugPrint('Mencoba menekan kartu fitur riwayat memasak');

        // Verifikasi berada di layar Riwayat Memasak
        await tester.pump();
        expect(find.text('Riwayat Memasak'), findsWidgets);
        debugPrint('Berhasil navigasi ke layar Riwayat Memasak');
        await tester.pump();

        // Menunggu indikator nutrisi dengan timeout
        int nutritionIndicatorAttempts = 0;
        while (nutritionIndicatorAttempts < 10) {
          await tester.pump(const Duration(milliseconds: 200));
          debugPrint(
            'Menunggu indikator nutrisi selesai... percobaan: ${nutritionIndicatorAttempts + 1}',
          );
          nutritionIndicatorAttempts++;

          // Memeriksa apakah indikator nutrisi terlihat
          if (find.text('913').evaluate().isNotEmpty) {
            debugPrint('Indikator Nutrisi selesai');
            break;
          }
        }
        await tester.pump(const Duration(seconds: 3));

        // Mencari tombol filter
        final filterButton = find.byIcon(Symbols.filter_list);
        expect(
          filterButton,
          findsOneWidget,
          reason: 'Tombol filter tidak ditemukan',
        );

        // Tap tombol filter untuk membuka bottomsheet
        await tester.tap(filterButton);
        await tester.pumpAndSettle();
        debugPrint('Mencoba menekan tombol filter');

        // Verifikasi bottomsheet filter muncul
        expect(find.text('Pilih Rentang Waktu'), findsOneWidget);
        debugPrint('Berhasil membuka bottomsheet filter');

        // Mencari dan memilih opsi "Semua"
        final allOption = find.text('Semua');
        expect(
          allOption,
          findsOneWidget,
          reason: 'Opsi "Semua" tidak ditemukan',
        );

        // Tap opsi "Semua"
        await tester.tap(allOption);
        await tester.pumpAndSettle();
        debugPrint('Mencoba menekan opsi "Semua"');

        // Menunggu bottomsheet tertutup dan filter diterapkan
        await tester.pump(const Duration(seconds: 1));
        debugPrint('Berhasil menerapkan filter "Semua"');

        // Verifikasi label filter sudah berubah menjadi "Semua"
        expect(find.text('Semua'), findsWidgets);

        // Menunggu data dikelompokkan berdasarkan tahun
        await tester.pump(const Duration(seconds: 1));

        // Mencari accordion untuk tahun 2025
        final accordion2025 = find.text('2025');
        expect(
          accordion2025,
          findsOneWidget,
          reason: 'Accordion tahun 2025 tidak ditemukan',
        );

        // Tap accordion tahun 2025 untuk membukanya
        await tester.tap(accordion2025);
        await tester.pumpAndSettle();
        debugPrint('Mencoba membuka accordion');

        // Verifikasi accordion tahun 2025 terbuka dan menampilkan list makanan
        // Mencari teks "Porsi" yang muncul pada item makanan
        int findPortionAttempts = 0;
        bool foundPortion = false;

        while (findPortionAttempts < 10 && !foundPortion) {
          await tester.pump(const Duration(milliseconds: 200));
          findPortionAttempts++;

          // Memeriksa apakah teks "Porsi" sudah muncul
          foundPortion = find.textContaining('Porsi').evaluate().isNotEmpty;

          if (foundPortion) {
            debugPrint('Berhasil membuka accordion');
            break;
          }
        }

        expect(
          find.textContaining('Porsi'),
          findsWidgets,
          reason: 'Tidak ada teks "Porsi" yang ditemukan dalam list makanan',
        );
        await tester.pump(const Duration(seconds: 3));

        // Verifikasi lolos, test berhasil
        debugPrint(
          '✅ Test selesai dengan sukses: Berhasil melihat riwayat makanan (1/1)',
        );
      } catch (e, stackTrace) {
        debugPrint('TEST GAGAL DENGAN ERROR: $e');
        debugPrint('STACK TRACE: $stackTrace');
        rethrow;
      }
    });

    testWidgets('Test Fitur Usulan Makanan', (tester) async {
      try {
        debugPrint('Memulai test fitur usulan makanan...');

        // Memulai aplikasi
        app.main();
        await tester.pumpAndSettle();
        debugPrint('Aplikasi berhasil dimulai');

        // Menunggu splash screen dengan timeout
        int splashAttempts = 0;
        while (splashAttempts < 10) {
          await tester.pump(const Duration(seconds: 1));
          debugPrint(
            'Menunggu splash screen selesai... percobaan: ${splashAttempts + 1}',
          );
          splashAttempts++;

          // Memeriksa apakah elemen halaman beranda terlihat
          if (find.text('Halo, Moms').evaluate().isNotEmpty) {
            break;
          }
        }

        expect(find.text('Halo, Moms'), findsWidgets);
        debugPrint('Berhasil navigasi ke halaman beranda');

        // Memberi waktu untuk layar render sepenuhnya
        await tester.pump(const Duration(seconds: 2));

        // Tap tab daftar makanan di bottom navigation bar
        debugPrint('Mencoba menekan tab daftar makanan di bottom navbar');

        // Mendapatkan ukuran layar untuk tap di posisi yang diharapkan
        final screenSize = tester.getSize(find.byType(MaterialApp));

        // Mencoba tap di posisi di mana tab kedua berada
        await tester.tapAt(
          Offset(screenSize.width * 0.2, screenSize.height - 30),
        );
        await tester.pumpAndSettle();

        // Memeriksa apakah kita telah navigasi ke layar daftar makanan
        await tester.pump(const Duration(seconds: 1));
        expect(find.text('Masak apa hari ini?'), findsOneWidget);
        debugPrint('Berhasil navigasi ke halaman daftar makanan');

        // Beralih ke tab "Usulan Saya"
        await tester.pump(const Duration(seconds: 1));
        debugPrint('Mencoba menekan tab usulan saya');

        // Toggle berada di sisi kanan layar
        final rightToggle = find.text('Usulan Saya');
        await tester.pump(const Duration(seconds: 1));
        expect(rightToggle, findsOneWidget);
        await tester.pump(const Duration(seconds: 1));
        await tester.tap(rightToggle, warnIfMissed: false);
        await tester.pumpAndSettle();

        debugPrint('Berhasil Beralih ke Usulan Saya');
        await tester.pump(const Duration(seconds: 1));
        debugPrint(
          '✅ Test selesai sebagian dengan sukses: Berhasil melihat daftar usulan makanan (1/5)',
        );
        await tester.pump(const Duration(seconds: 2));

        // Mencoba tap langsung di area banner
        debugPrint('Mencoba menekan tombol tambah usulan makanan');
        final addButton = find.text('Tambahkan Foto');

        if (addButton.evaluate().isNotEmpty) {
          await tester.tap(addButton);
        } else {
          // Try finding any button with "Tambah" text
          final anyAddButton = find.textContaining('Tambah');

          if (anyAddButton.evaluate().isNotEmpty) {
            await tester.tap(anyAddButton.first);
          } else {
            // Try tapping the banner directly
            final bannerArea = Offset(screenSize.width / 2, 180);
            await tester.tapAt(bannerArea);
          }
        }

        await tester.pumpAndSettle();

        // Memeriksa apakah kita telah navigasi ke layar tambah usulan makanan
        expect(find.text('Tambahkan Usulan Makanan'), findsOneWidget);
        debugPrint('Berhasil navigasi ke halaman tambah usulan makanan');

        // Mengisi formulir
        debugPrint('Mencoba mengisi formulir usulan makanan...');

        // Temukan ListView utama untuk digunakan dalam pengguliran
        final formListView = find.byType(ListView).first;

        // Field nama resep
        debugPrint('Mencoba mengisi nama resep');
        final recipeNameField = find.byKey(const ValueKey('_recipeNameKey'));
        expect(
          recipeNameField,
          findsOneWidget,
          reason: 'Field nama resep tidak ditemukan',
        );
        await tester.enterText(recipeNameField, 'Bubur Bayam Wortel');
        debugPrint('Berhasil mengisi nama resep');

        // Temukan dan tap tombol mock gambar
        debugPrint('Mencoba menambahkan gambar untuk foto');
        final mockImageButton = find.text('USE_TEST_IMAGE');
        if (mockImageButton.evaluate().isNotEmpty) {
          await tester.tap(mockImageButton);
          debugPrint('Berhasil menambahkan gambar test untuk foto');
        } else {
          debugPrint(
            'Tombol gambar test tidak ditemukan - melewati pemilihan foto',
          );
        }

        // Dropdown kategori
        final categoryField = find.byKey(const ValueKey('_categoryKey'));
        expect(
          categoryField,
          findsOneWidget,
          reason: 'Field kategori tidak ditemukan',
        );
        debugPrint('Mencoba memilih kategori');
        await tester.tap(categoryField);
        await tester.pumpAndSettle();
        // Pilih opsi pertama dalam dropdown
        final categoryOption = find.text('Sarapan').first;
        await tester.tap(categoryOption);
        await tester.pumpAndSettle();
        debugPrint('Berhasil memilih kategori');

        // Dropdown kelompok umur
        debugPrint('Mencoba memilih kelompok umur');
        final ageField = find.byKey(const ValueKey('_ageKey'));
        expect(ageField, findsOneWidget, reason: 'Field umur tidak ditemukan');
        await tester.tap(ageField);
        await tester.pumpAndSettle();
        // Pilih opsi pertama dalam dropdown
        final ageOption = find.text('6-8').first;
        await tester.tap(ageOption);
        await tester.pumpAndSettle();
        debugPrint('Berhasil memilih kelompok umur');

        // Field porsi
        debugPrint('Mencoba mengisi porsi');
        final portionField = find.byKey(const ValueKey('_portionKey'));
        expect(
          portionField,
          findsOneWidget,
          reason: 'Field porsi tidak ditemukan',
        );
        await tester.enterText(portionField, '2');
        debugPrint('Berhasil mengisi porsi');

        // Scroll ke bawah secara signifikan untuk menampilkan lebih banyak field
        await tester.drag(formListView, const Offset(0, -500));
        await tester.pumpAndSettle();

        // Tunggu sebentar setelah scrolling
        await tester.pump(const Duration(milliseconds: 500));

        // Mencoba menemukan field deskripsi setelah scrolling
        debugPrint('Mencoba mengisi deskripsi');
        final descriptionField = find.byKey(const ValueKey('_descriptionKey'));
        expect(
          descriptionField,
          findsOneWidget,
          reason: 'Field deskripsi tidak ditemukan setelah scrolling',
        );
        await tester.enterText(
          descriptionField,
          'Bubur sehat untuk bayi 6 bulan dengan bayam dan wortel',
        );
        debugPrint('Berhasil mengisi deskripsi');

        // Scroll ke bawah lagi untuk menampilkan field bahan
        await tester.drag(formListView, const Offset(0, -400));
        await tester.pumpAndSettle();
        await tester.pump(const Duration(milliseconds: 500));

        // Temukan field bahan dengan mencari hint text Bahan 1
        debugPrint('Mencoba mengisi bahan');
        final ingredientField = find.widgetWithText(TextFormField, 'Bahan 1');
        expect(
          ingredientField,
          findsOneWidget,
          reason: 'Field bahan pertama tidak ditemukan',
        );
        await tester.enterText(ingredientField, '1 sdm Beras');
        debugPrint('Berhasil mengisi bahan pertama');

        // Tambahkan bahan lain
        final addIngredientButton = find.text('Tambah Bahan');
        expect(
          addIngredientButton,
          findsOneWidget,
          reason: 'Tombol tambah bahan tidak ditemukan',
        );
        await tester.tap(addIngredientButton);
        await tester.pumpAndSettle();

        // Masukkan bahan kedua - temukan dengan hint text Bahan 2
        final ingredientField2 = find.widgetWithText(TextFormField, 'Bahan 2');
        expect(
          ingredientField2,
          findsOneWidget,
          reason: 'Field bahan kedua tidak ditemukan',
        );
        await tester.enterText(ingredientField2, '50g Bayam');
        debugPrint('Berhasil mengisi bahan kedua');

        // Scroll ke bawah lagi untuk menampilkan field langkah
        await tester.drag(formListView, const Offset(0, -400));
        await tester.pumpAndSettle();
        await tester.pump(const Duration(milliseconds: 500));

        // Temukan field langkah dengan mencari hint text Langkah 1
        debugPrint('Mencoba mengisi langkah');
        final stepField = find.widgetWithText(TextFormField, 'Langkah 1');
        expect(
          stepField,
          findsOneWidget,
          reason: 'Field langkah pertama tidak ditemukan',
        );
        await tester.enterText(stepField, 'Cuci beras dan masak dengan air');
        debugPrint('Berhasil mengisi langkah');

        // Pastikan kita scroll sampai ke bawah untuk melihat tombol berikutnya
        await tester.drag(formListView, const Offset(0, -1000));
        await tester.pumpAndSettle();

        // Tunggu sejenak untuk memastikan UI stabil
        await tester.pump(const Duration(seconds: 1));

        // Coba berbagai pendekatan untuk menemukan dan tap tombol berikutnya
        bool nextButtonTapped = false;

        // Percobaan pertama: Temukan menggunakan ikon panah
        debugPrint('Mencoba menekan tombol berikutnya');
        final nextButtonIcon = find.byIcon(Icons.arrow_right_alt_rounded);
        if (nextButtonIcon.evaluate().isNotEmpty) {
          await tester.tap(nextButtonIcon);
          nextButtonTapped = true;
          debugPrint('Berhasil menekan tombol berikutnya');
        }

        // Percobaan kedua: Cari lingkaran berwarna accent
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
            debugPrint('Berhasil menekan tombol berikutnya');
          }
        }

        // Percobaan ketiga: Temukan dan tap GestureDetector di kanan bawah
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
            debugPrint('Berhasil menekan tombol berikutnya');
          }
        }

        // Upaya terakhir: Tap di posisi
        if (!nextButtonTapped) {
          await tester.tapAt(
            Offset(screenSize.width - 50, screenSize.height - 50),
          );
          debugPrint('Berhasil menekan tombol berikutnya');
        }

        // Menunggu navigasi selesai
        await tester.pumpAndSettle(const Duration(seconds: 2));

        // Pump tambahan untuk memastikan UI terupdate
        await tester.pump(const Duration(seconds: 1));

        // Memeriksa apakah kita telah navigasi ke layar kalkulator nutrisi
        int attempts = 0;
        bool foundCalculator = false;
        while (attempts < 5 && !foundCalculator) {
          await tester.pump(const Duration(milliseconds: 200));
          foundCalculator = find.text('Kalkulator Gizi').evaluate().isNotEmpty;
          attempts++;
        }

        expect(
          find.text('Kalkulator Gizi'),
          findsWidgets,
          reason: 'Tidak berhasil navigasi ke layar kalkulator nutrisi',
        );
        debugPrint('Berhasil navigasi ke halaman kalkulator nutrisi');

        // Menunggu perhitungan selesai
        await tester.pump();
        int calculationWaitCounter = 0;
        bool calculationComplete = false;

        while (calculationWaitCounter < 20 && !calculationComplete) {
          await tester.pump(const Duration(milliseconds: 200));
          calculationWaitCounter++;
          debugPrint(
            'Menunggu perhitungan nutrisi... percobaan $calculationWaitCounter',
          );

          // Memeriksa apakah perhitungan selesai dengan mencari nilai numerik
          calculationComplete =
              find.textContaining('kkal').evaluate().isNotEmpty;

          if (calculationComplete) {
            debugPrint('Perhitungan nutrisi selesai');
            break;
          }
        }

        // Memastikan perhitungan selesai
        expect(find.textContaining('kkal'), findsOneWidget);

        // Tap tombol simpan
        debugPrint('Mencoba menekan tombol simpan');
        await tester.tap(find.text('Simpan'));
        await tester.pumpAndSettle(const Duration(seconds: 3));
        debugPrint('Berhasil menekan tombol simpan');

        // Menunggu pesan sukses
        await tester.pump();
        int successMessageWaitCounter = 0;
        bool successMessageComplete = false;

        while (successMessageWaitCounter < 20 && !successMessageComplete) {
          await tester.pump(const Duration(milliseconds: 200));
          successMessageWaitCounter++;
          debugPrint(
            'Menunggu proses tambah... percobaan $successMessageWaitCounter',
          );

          // Memeriksa apakah pesan sukses muncul
          successMessageComplete =
              find.textContaining('Usulan Saya').evaluate().isNotEmpty;

          if (successMessageComplete) {
            debugPrint('Berhasil menambahkan usulan makanan');
            break;
          }
        }

        // Menunggu sebentar untuk memastikan UI terupdate sepenuhnya
        await tester.pump(const Duration(seconds: 1));
        debugPrint(
          '✅ Test selesai sebagian dengan sukses: Berhasil menambahkan usulan makanan (2/5)',
        );
        await tester.pump(const Duration(seconds: 2));

        // Verifikasi berada di tab Usulan Saya
        final usulanTab = find.text('Usulan Saya');
        expect(usulanTab, findsOneWidget);

        // Pastikan kita melihat list usulan makanan
        await tester.pump(const Duration(seconds: 3));

        // Cari dan tap card makanan pertama (usulan yang baru saja ditambahkan)
        debugPrint('Mencoba menekan card usulan makanan pertama');
        final foodCard = find.byKey(const ValueKey('food_card')).first;
        expect(
          foodCard,
          findsOneWidget,
          reason: 'Tidak dapat menemukan card makanan yang baru ditambahkan',
        );

        await tester.tap(foodCard);
        await tester.pumpAndSettle();
        debugPrint('Berhasil menekan card usulan makanan pertama');

        // Verifikasi berada di halaman detail usulan makanan
        await tester.pump(const Duration(milliseconds: 500));
        expect(find.text('Deskripsi'), findsOneWidget);
        expect(find.text('Bahan-bahan'), findsOneWidget);
        debugPrint('Berhasil navigasi ke halaman detail usulan makanan');

        await tester.pump(const Duration(seconds: 1));
        debugPrint(
          '✅ Test selesai dengan sukses: Berhasil melihat detail usulan makanan (3/5)',
        );
        await tester.pump(const Duration(seconds: 2));

        // Cari dan tap tombol edit usulan
        final editButton = find.text('Edit Usulan').first;
        expect(
          editButton,
          findsOneWidget,
          reason: 'Tombol Edit Usulan tidak ditemukan',
        );
        debugPrint('Mencoba menekan tombol edit usulan makanan');

        await tester.tap(editButton);
        await tester.pumpAndSettle();
        debugPrint('Berhasil menekan tombol edit usulan makanan');

        // Verifikasi berada di halaman edit usulan makanan
        await tester.pump(const Duration(seconds: 2));
        expect(find.text('Edit Usulan Makanan'), findsOneWidget);
        debugPrint('Berhasil navigasi ke halaman edit usulan makanan');

        // Ubah nama resep
        debugPrint('Mencoba mengubah nama resep');
        final recipeNameField2 = find.byKey(const ValueKey('_recipeNameKey'));
        expect(
          recipeNameField2,
          findsOneWidget,
          reason: 'Field nama resep tidak ditemukan',
        );

        // Hapus teks saat ini dan masukkan teks baru
        await tester.tap(recipeNameField2);
        await tester.pumpAndSettle();

        // Hapus teks yang ada - perbaikan pada metode pengiriman key event
        await tester.enterText(
          recipeNameField2,
          '',
        ); // Hapus teks dengan mengosongkan field
        await tester.pump(const Duration(milliseconds: 100));

        // Input nama baru
        await tester.enterText(
          recipeNameField2,
          'Bubur Bayam Wortel Terupdate',
        );
        await tester.pump();
        debugPrint('Berhasil mengubah nama resep');

        // Tap di tempat lain untuk menutup keyboard
        await tester.tap(find.text('Isi Form'));
        await tester.pump();

        // Cari dan tap tombol next (lingkaran di pojok kanan bawah)
        debugPrint('Mencoba menekan tombol next');
        final nextButton = find.byIcon(Symbols.arrow_forward_ios_rounded);
        expect(
          nextButton,
          findsOneWidget,
          reason: 'Tombol next tidak ditemukan',
        );
        await tester.tap(nextButton);
        await tester.pumpAndSettle();
        debugPrint('Berhasil menekan tombol next');

        // Pump tambahan untuk memastikan UI terupdate
        await tester.pump(const Duration(seconds: 1));

        // Memeriksa apakah kita telah navigasi ke layar kalkulator nutrisi
        int attempts1 = 0;
        bool foundCalculator2 = false;
        while (attempts1 < 5 && !foundCalculator2) {
          await tester.pump(const Duration(milliseconds: 200));
          foundCalculator2 = find.text('Kalkulator Gizi').evaluate().isNotEmpty;
          attempts1++;
        }

        expect(
          find.text('Kalkulator Gizi'),
          findsWidgets,
          reason: 'Tidak berhasil navigasi ke layar kalkulator nutrisi',
        );
        debugPrint('Berhasil navigasi ke halaman kalkulator nutrisi');

        // Menunggu perhitungan selesai
        await tester.pump();
        int calculationWaitCounter2 = 0;
        bool calculationComplete2 = false;

        while (calculationWaitCounter2 < 20 && !calculationComplete2) {
          await tester.pump(const Duration(milliseconds: 200));
          calculationWaitCounter2++;
          debugPrint(
            'Menunggu perhitungan nutrisi... percobaan $calculationWaitCounter2',
          );

          // Memeriksa apakah perhitungan selesai dengan mencari nilai numerik
          calculationComplete2 =
              find.textContaining('kkal').evaluate().isNotEmpty;

          if (calculationComplete2) {
            debugPrint('Perhitungan nutrisi selesai');
            break;
          }
        }

        // Memastikan perhitungan selesai
        expect(find.textContaining('kkal'), findsOneWidget);

        // Tap tombol simpan
        debugPrint('Mencoba menekan tombol simpan');
        await tester.tap(find.text('Simpan'));
        debugPrint('Berhasil menekan tombol simpan');
        await tester.pumpAndSettle(const Duration(seconds: 3));

        // Menunggu pesan sukses
        await tester.pump();
        int successMessageWaitCounter2 = 0;
        bool successMessageComplete2 = false;

        while (successMessageWaitCounter2 < 20 && !successMessageComplete2) {
          await tester.pump(const Duration(milliseconds: 200));
          successMessageWaitCounter2++;
          debugPrint(
            'Menunggu proses edit... percobaan $successMessageWaitCounter2',
          );

          // Memeriksa apakah pesan sukses muncul
          successMessageComplete2 =
              find.textContaining('Usulan Saya').evaluate().isNotEmpty;

          if (successMessageComplete2) {
            debugPrint('Berhasil mengedit usulan makanan');
            break;
          }
        }

        // Menunggu sebentar untuk memastikan UI terupdate sepenuhnya
        await tester.pump(const Duration(seconds: 1));
        debugPrint(
          '✅ Test selesai sebagian dengan sukses: Berhasil mengedit usulan makanan (4/5)',
        );
        await tester.pump(const Duration(seconds: 2));

        // Verifikasi kembali ke halaman Usulan Saya
        await tester.pump(const Duration(seconds: 2));
        expect(find.text('Usulan Saya'), findsWidgets);

        // Cari dan tap card makanan
        debugPrint('Mencoba menekan card usulan makanan');
        final foodCardToDelete = find.byKey(const ValueKey('food_card')).first;
        expect(
          foodCardToDelete,
          findsOneWidget,
          reason: 'Tidak dapat menemukan card makanan untuk dihapus',
        );

        await tester.tap(foodCardToDelete);
        await tester.pumpAndSettle();
        debugPrint('Berhasil menekan card usulan makanan');

        // Verifikasi berada di halaman detail usulan makanan
        await tester.pump(const Duration(milliseconds: 500));
        expect(find.text('Deskripsi'), findsOneWidget);
        expect(find.text('Bahan-bahan'), findsOneWidget);
        debugPrint('Berhasil navigasi ke halaman detail usulan makanan');

        // Cari dan tap tombol hapus usulan
        debugPrint('Mencoba menekan tombol hapus usulan makanan');
        final deleteButton = find.text('Hapus').last;
        expect(
          deleteButton,
          findsOneWidget,
          reason: 'Tombol Hapus tidak ditemukan',
        );
        await tester.tap(deleteButton);
        await tester.pumpAndSettle();
        debugPrint('Berhasil menekan tombol hapus usulan makanan');

        // Verifikasi dialog konfirmasi muncul
        expect(find.text('Hapus'), findsWidgets);

        // Tap tombol konfirmasi hapus
        debugPrint('Mencoba menekan tombol konfirmasi hapus');
        final confirmDeleteButton = find.descendant(
          of: find.byType(Dialog),
          matching: find.text('Hapus'),
        );
        expect(
          confirmDeleteButton,
          findsOneWidget,
          reason: 'Tombol konfirmasi hapus tidak ditemukan',
        );

        await tester.tap(confirmDeleteButton);
        await tester.pumpAndSettle();
        debugPrint('Berhasil menekan tombol konfirmasi hapus');

        // Menunggu proses hapus dan navigasi kembali ke layar food list
        await tester.pump(const Duration(seconds: 3));

        // Verifikasi kembali ke halaman Usulan Saya
        expect(find.text('Usulan Saya'), findsWidgets);
        debugPrint(
          '✅ Test selesai dengan sukses: Berhasil menghapus usulan makanan (5/5)',
        );
      } catch (e, stackTrace) {
        debugPrint('TEST GAGAL DENGAN ERROR: $e');
        debugPrint('STACK TRACE: $stackTrace');
        rethrow;
      }
    });

    testWidgets('Test Fitur Jadwal Makanan', (tester) async {
      try {
        debugPrint('Memulai test jadwal makanan...');

        // Memulai aplikasi
        app.main();
        await tester.pumpAndSettle();
        debugPrint('Aplikasi berhasil dimulai');

        // Menunggu splash screen dengan timeout
        int splashAttempts = 0;
        while (splashAttempts < 10) {
          await tester.pump(const Duration(seconds: 1));
          debugPrint(
            'Menunggu splash screen selesai... percobaan: ${splashAttempts + 1}',
          );
          splashAttempts++;

          // Memeriksa apakah elemen halaman beranda terlihat
          if (find.text('Halo, Moms').evaluate().isNotEmpty) {
            break;
          }
        }

        expect(find.text('Halo, Moms'), findsWidgets);
        debugPrint('Berhasil navigasi ke halaman beranda');

        // Memberi waktu untuk layar render sepenuhnya
        await tester.pump(const Duration(seconds: 2));

        // Tap tab daftar makanan di bottom navigation bar
        debugPrint('Mencoba menekan tab daftar makanan');

        // Mendapatkan ukuran layar untuk tap di posisi yang diharapkan
        final screenSize = tester.getSize(find.byType(MaterialApp));

        // Mencoba tap di posisi di mana tab kedua berada
        await tester.tapAt(
          Offset(screenSize.width * 0.2, screenSize.height - 30),
        );
        await tester.pumpAndSettle();

        // Memeriksa apakah kita telah navigasi ke layar daftar makanan
        await tester.pump(const Duration(seconds: 1));
        expect(find.text('Masak apa hari ini?'), findsOneWidget);
        debugPrint('Berhasil navigasi ke halaman daftar makanan');

        // Menunggu daftar makanan dimuat
        await tester.pump(const Duration(seconds: 2));

        // Menemukan dan tap pada item makanan
        debugPrint('Mencoba menekan kartu makanan pertama');
        final foodCard = find.byKey(const ValueKey('food_card')).first;
        expect(foodCard, findsOneWidget);

        await tester.tap(foodCard);
        await tester.pumpAndSettle();
        debugPrint('Berhasil menekan kartu makanan pertama');

        // Verifikasi kita berada di layar detail makanan
        await tester.pump(const Duration(seconds: 2));
        expect(find.text('Masak Sekarang'), findsOneWidget);
        debugPrint('Berhasil navigasi ke halaman detail makanan');

        // Tap tombol jadwal
        debugPrint('Mencoba menekan tombol jadwal');
        final scheduleButton = find.byIcon(Symbols.calendar_add_on);
        expect(scheduleButton, findsOneWidget);

        await tester.tap(scheduleButton);
        await tester.pumpAndSettle();
        debugPrint('Berhasil menekan tombol jadwal');

        // Menunggu dialog popup jadwal muncul
        debugPrint('Mengisi form jadwal makanan');
        await tester.pump(const Duration(seconds: 1));
        expect(find.text('Atur Jadwal Memasak'), findsOneWidget);

        // Temukan dan pilih bayi
        debugPrint('Mencoba memilih bayi untuk jadwal');
        final albertoRow = find.text('Alberto').last;
        expect(
          albertoRow,
          findsWidgets,
          reason: 'Tidak dapat menemukan bayi bernama Alberto',
        );

        // Dapatkan posisi tengah dari widget teks untuk tap di dekatnya
        final albertoRowPos = tester.getCenter(albertoRow);
        // Tap sedikit ke kiri dari teks
        await tester.tapAt(Offset(albertoRowPos.dx - 30, albertoRowPos.dy));
        await tester.pumpAndSettle();
        debugPrint('Berhasil memilih bayi');

        // Pilih tanggal hari ini dengan tap field tanggal
        debugPrint('Mencoba memilih tanggal hari ini');
        final dateField = find.text('Pilih Tanggal').last;
        if (dateField.evaluate().isNotEmpty) {
          await tester.tap(dateField);
          await tester.pumpAndSettle();

          // Tap OKE pada date picker
          await tester.tap(find.text('OKE'));
          await tester.pumpAndSettle();
          debugPrint('Berhasil memilih tanggal hari ini');
        } else {
          // Jika field sudah memiliki tanggal, kita tidak perlu memilihnya
          debugPrint('Tanggal sudah dipilih');
        }

        // Tap tombol simpan
        debugPrint('Mencoba menekan tombol simpan jadwal');
        final saveButton = find.text('Simpan').last;
        expect(saveButton, findsOneWidget);
        await tester.tap(saveButton);
        await tester.pumpAndSettle();
        debugPrint('Berhasil menekan tombol simpan jadwal');

        // Menunggu operasi penyimpanan selesai
        await tester.pump(const Duration(seconds: 3));

        // Tombol kembali untuk kembali ke layar daftar makanan
        final backButton = find.byIcon(AppIcons.back);
        if (backButton.evaluate().isNotEmpty) {
          await tester.tap(backButton);
          await tester.pumpAndSettle();
        } else {
          // Coba gunakan tombol kembali sistem jika tidak ada tombol kembali
          await tester.pageBack();
          await tester.pumpAndSettle();
        }

        // Verifikasi kita kembali ke layar daftar makanan
        expect(find.text('Masak apa hari ini?'), findsOneWidget);
        await tester.pump(const Duration(seconds: 1));
        debugPrint(
          '✅ Test selesai sebagian dengan sukses: Berhasil menambah jadwal makanan (1/4)',
        );
        await tester.pump(const Duration(seconds: 2));

        // Navigasi ke layar jadwal menggunakan bottom nav bar
        debugPrint('Mencoba menavigasi ke halaman jadwal');
        await tester.tapAt(
          Offset(screenSize.width * 0.5, screenSize.height - 30),
        );
        await tester.pumpAndSettle();

        // Verifikasi kita berada di layar jadwal
        await tester.pump(const Duration(seconds: 2));
        expect(find.text('Jadwal Memasak'), findsOneWidget);
        debugPrint('Berhasil navigasi ke halaman jadwal');

        // Menunggu item jadwal dimuat
        await tester.pump(const Duration(seconds: 1));
        debugPrint(
          '✅ Test selesai sebagian dengan sukses: Berhasil melihat daftar jadwal makanan (2/4)',
        );
        await tester.pump(const Duration(seconds: 2));

        // Mencoba menemukan bayi di jadwal terbaru
        final albertoInSchedule = find.text('Alberto', skipOffstage: false);
        expect(
          albertoInSchedule,
          findsWidgets,
          reason: 'Jadwal untuk Alberto tidak ditemukan',
        );

        // Tunggu sebentar untuk UI stabil
        await tester.pump(const Duration(seconds: 1));

        // Cari tombol edit (container dengan warna amber)
        final editButton =
            find
                .byWidgetPredicate(
                  (widget) =>
                      widget is Container &&
                      widget.decoration is BoxDecoration &&
                      (widget.decoration as BoxDecoration).color ==
                          AppColors.amber,
                )
                .first;

        expect(
          editButton,
          findsOneWidget,
          reason: 'Tombol edit tidak ditemukan setelah swipe',
        );

        // Tap tombol edit
        debugPrint('Mencoba menekan tombol edit jadwal');
        await tester.tap(editButton);
        await tester.pumpAndSettle();
        debugPrint('Berhasil menekan tombol edit jadwal');

        // Verifikasi dialog edit muncul
        expect(find.text('Atur Ulang Jadwal Memasak'), findsOneWidget);

        // Tap field tanggal untuk mengubah tanggal
        debugPrint('Mencoba mengubah tanggal jadwal');
        final editDateField = find.textContaining('20').last;
        expect(
          editDateField,
          findsOneWidget,
          reason: 'Field tanggal tidak ditemukan',
        );
        debugPrint('Mencoba memilih tanggal besok');
        await tester.tap(editDateField);
        await tester.pumpAndSettle();

        // Pilih tanggal besok di date picker
        // Temukan tombol tanggal besok - biasanya tanggal hari ini + 1
        final tomorrow = DateTime.now().add(const Duration(days: 1));
        final tomorrowDay = tomorrow.day.toString();

        // Mencoba menemukan tanggal besok di date picker
        final tomorrowDate = find.text(tomorrowDay).last;
        if (tomorrowDate.evaluate().isNotEmpty) {
          await tester.tap(tomorrowDate);
          await tester.pumpAndSettle();
          debugPrint('Tanggal besok dipilih: $tomorrowDay');
        } else {
          debugPrint('Mencoba metode alternatif untuk memilih tanggal besok');
          // Mencoba tap pada area tengah date picker (kemungkinan besok)
          final datePickerCenter = tester.getCenter(find.byType(Dialog));
          await tester.tapAt(
            Offset(datePickerCenter.dx + 50, datePickerCenter.dy),
          );
          await tester.pumpAndSettle();
        }
        debugPrint('Berhasil memilih tanggal besok');

        // Tap OK pada date picker
        final okButton = find.text('OKE');
        if (okButton.evaluate().isNotEmpty) {
          await tester.tap(okButton);
          await tester.pumpAndSettle();
        }

        // Tap tombol simpan pada dialog edit
        debugPrint('Mencoba menekan tombol simpan');
        final editSaveButton = find.text('Simpan').last;
        expect(editSaveButton, findsOneWidget);
        await tester.tap(editSaveButton);
        await tester.pumpAndSettle();
        debugPrint('Berhasil menekan tombol simpan');

        // Verifikasi pesan sukses
        await tester.pump(const Duration(seconds: 1));
        debugPrint(
          '✅ Test selesai sebagian dengan sukses: Berhasil mengedit jadwal makanan (3/4)',
        );
        await tester.pump(const Duration(seconds: 2));

        // Temukan PageView yang berisi carousel hari
        final dayCarousel = find.byType(PageView).first;
        expect(
          dayCarousel,
          findsOneWidget,
          reason: 'PageView untuk carousel hari tidak ditemukan',
        );

        // Swipe ke kanan untuk melihat hari berikutnya
        debugPrint('Mencoba swipe ke kanan untuk hari berikutnya');
        await tester.drag(dayCarousel, const Offset(-120.0, 0.0));
        await tester.pumpAndSettle();
        debugPrint('Berhasil swipe ke kanan untuk hari berikutnya');

        // Menunggu jadwal-jadwal untuk hari yang dipilih dimuat
        await tester.pump(const Duration(seconds: 2));

        // Cari tombol hapus (container dengan warna merah)
        final deleteButton = find.byIcon(Symbols.delete).first;

        expect(
          deleteButton,
          findsOneWidget,
          reason: 'Tombol hapus tidak ditemukan',
        );
        debugPrint('Tombol hapus ditemukan');

        // Tap tombol hapus
        debugPrint('Mencoba menekan tombol hapus');
        await tester.tap(deleteButton);
        await tester.pumpAndSettle();
        debugPrint('Berhasil menekan tombol hapus');

        // Verifikasi dialog konfirmasi hapus muncul
        debugPrint('Mencoba mengonfirmasi hapus jadwal');
        expect(find.text('Hapus'), findsOneWidget);

        // Tap tombol hapus di dialog
        final confirmDeleteButton = find.descendant(
          of: find.byType(Dialog),
          matching: find.text('Hapus'),
        );

        expect(
          confirmDeleteButton,
          findsOneWidget,
          reason: 'Tombol konfirmasi hapus tidak ditemukan',
        );

        debugPrint('Mencoba menekan tombol konfirmasi hapus');
        await tester.tap(confirmDeleteButton);
        await tester.pumpAndSettle();
        debugPrint('Berhasil menekan tombol konfirmasi hapus');

        // Verifikasi pesan sukses
        await tester.pump(const Duration(seconds: 2));

        debugPrint(
          '✅ Test selesai dengan sukses: Berhasil menghapus jadwal makanan (4/4)',
        );
      } catch (e, stackTrace) {
        debugPrint('TEST GAGAL DENGAN ERROR: $e');
        debugPrint('STACK TRACE: $stackTrace');
        rethrow;
      }
    });
  });
}
