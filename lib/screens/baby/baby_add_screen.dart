import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:nutrimpasi/blocs/baby/baby_bloc.dart';
import 'package:nutrimpasi/constants/colors.dart';
import 'package:intl/intl.dart';
import 'package:nutrimpasi/utils/flushbar.dart';
import 'package:bottom_picker/bottom_picker.dart';
import 'package:bottom_picker/resources/arrays.dart';

class BabyAddScreen extends StatefulWidget {
  const BabyAddScreen({super.key});

  @override
  State<BabyAddScreen> createState() => _BabyAddScreenState();
}

class _BabyAddScreenState extends State<BabyAddScreen> {
  // Form key untuk validasi input
  final _formKey = GlobalKey<FormState>();

  // Controller untuk field input (semua diinisialisasi kosong)
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _allergyController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();

  // Default value untuk jenis kelamin
  String _gender = 'L';
  DateTime? _selectedDate;

  @override
  void dispose() {
    // Pembersihan controller untuk mencegah memory leak
    _nameController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _allergyController.dispose();
    _birthDateController.dispose();
    super.dispose();
  }

  /// Fungsi untuk menampilkan date picker dan memilih tanggal lahir
  Future<void> _selectDate(BuildContext context) async {
    // Tanggal minimal adalah 24 bulan (2 tahun) yang lalu
    final twoYearsAgo = DateTime.now().subtract(const Duration(days: 730));
    // Tanggal maksimal adalah 6 bulan yang lalu
    final sixMonthsAgo = DateTime.now().subtract(const Duration(days: 182));

    // Memastikan initial date dalam range yang valid
    final initialDate =
        _selectedDate != null
            ? _selectedDate!
            : DateTime(sixMonthsAgo.year, sixMonthsAgo.month, sixMonthsAgo.day);

    BottomPicker.date(
      pickerTitle: Text(
        'Pilih Tanggal Lahir',
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: AppColors.textBlack,
        ),
      ),
      titleAlignment: Alignment.center,
      backgroundColor: Colors.white,
      buttonContent: const Text(
        'Pilih',
        style: TextStyle(color: Colors.white, fontSize: 16),
        textAlign: TextAlign.center,
      ),
      buttonSingleColor: AppColors.primary,
      displayCloseIcon: true,
      closeIconColor: AppColors.textBlack,
      closeIconSize: 24,
      initialDateTime: initialDate,
      maxDateTime: sixMonthsAgo,
      minDateTime: twoYearsAgo,
      dateOrder: DatePickerDateOrder.dmy,
      pickerTextStyle: const TextStyle(
        color: AppColors.textBlack,
        fontWeight: FontWeight.w500,
        fontSize: 14,
      ),
      onChange: (date) {},
      onSubmit: (date) {
        // Memastikan tanggal yang dipilih valid
        final selectedDate = date as DateTime;
        if (selectedDate.isAfter(sixMonthsAgo) ||
            selectedDate.isBefore(twoYearsAgo)) {
          AppFlushbar.showWarning(
            context,
            title: 'Perhatian!',
            message:
                'Tanggal harus antara ${DateFormat('d MMMM y', 'id_ID').format(twoYearsAgo)} dan ${DateFormat('d MMMM y', 'id_ID').format(sixMonthsAgo)}',
            marginVerticalValue: 8,
          );
          return;
        }

        setState(() {
          _selectedDate = selectedDate;
          _birthDateController.text = DateFormat(
            'EEEE, d MMMM y',
            'id_ID',
          ).format(selectedDate);
        });
      },
      bottomPickerTheme: BottomPickerTheme.plumPlate,
      height: 300,
    ).show(context);
  }

  /// Fungsi untuk menyimpan data bayi
  void _saveBaby() {
    if (_formKey.currentState!.validate()) {
      context.read<BabyBloc>().add(
        StoreBabies(
          name: _nameController.text,
          dob: _selectedDate!,
          gender: _gender,
          weight: double.parse(_weightController.text),
          height: double.parse(_heightController.text),
          condition: _allergyController.text,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      // AppBar dengan styling khusus
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        // Tombol kembali dengan styling custom
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Material(
            elevation: 5,
            shadowColor: Colors.black54,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                icon: const Icon(
                  Symbols.arrow_back_ios_new_rounded,
                  color: AppColors.textBlack,
                  size: 24,
                ),
                padding: EdgeInsets.zero,
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ),
        ),
        title: const Text(
          'Tambah Profil Bayi',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                // Lingkaran besar di belakang
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(50),
                            offset: const Offset(0, 8),
                            blurRadius: 8,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Lataran bawah dengan warna primer
                Container(
                  width: double.infinity,
                  height: 125,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(50),
                        offset: const Offset(0, 4),
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                ),

                // Lingkaran besar di depan (warna primer)
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),

                // Gambar bayi di tengah lingkaran
                Positioned(
                  top: 25,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(25),
                            blurRadius: 6,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      // Gambar bayi sesuai dengan jenis kelamin
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(
                          _gender == 'L'
                              ? 'assets/images/component/bayi_laki_laki.png'
                              : 'assets/images/component/bayi_perempuan.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 100),

            // Konten utama untuk form input data bayi
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Stack(
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 30),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(15),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      // Form untuk input data bayi
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Field nama bayi (required)
                            RichText(
                              text: const TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Nama Bayi',
                                    style: TextStyle(
                                      color: AppColors.textBlack,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                  TextSpan(
                                    text: '*',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            // Input field untuk nama bayi dengan validasi
                            TextFormField(
                              controller: _nameController,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: AppColors.componentGrey!,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: AppColors.componentGrey!,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: AppColors.componentGrey!,
                                  ),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                hintText: 'Masukkan nama bayi',
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Nama bayi tidak boleh kosong';
                                }
                                if (value.length < 4) {
                                  return 'Nama bayi minimal 4 karakter';
                                }
                                if (value.length > 255) {
                                  return 'Nama bayi maksimal 255 karakter';
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: 16),

                            // Pilihan jenis kelamin (required)
                            RichText(
                              text: const TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Jenis Kelamin',
                                    style: TextStyle(
                                      color: AppColors.textBlack,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                  TextSpan(
                                    text: '*',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            // Radio button untuk pilihan jenis kelamin
                            Row(
                              children: [
                                Radio(
                                  value: 'L',
                                  groupValue: _gender,
                                  activeColor: AppColors.primary,
                                  onChanged: (value) {
                                    setState(() {
                                      _gender = value!;
                                    });
                                  },
                                ),
                                const Text('Laki-Laki'),
                                const SizedBox(width: 20),
                                Radio(
                                  value: 'P',
                                  groupValue: _gender,
                                  activeColor: AppColors.primary,
                                  onChanged: (value) {
                                    setState(() {
                                      _gender = value!;
                                    });
                                  },
                                ),
                                const Text('Perempuan'),
                              ],
                            ),

                            const SizedBox(height: 16),

                            // Field tanggal lahir (required)
                            RichText(
                              text: const TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Tanggal Lahir',
                                    style: TextStyle(
                                      color: AppColors.textBlack,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                  TextSpan(
                                    text: '*',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            // Input field untuk tanggal lahir dengan date picker
                            TextFormField(
                              controller: _birthDateController,
                              readOnly: true,
                              onTap: () => _selectDate(context),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: AppColors.componentGrey!,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: AppColors.componentGrey!,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: AppColors.componentGrey!,
                                  ),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                hintText: 'Pilih tanggal lahir',
                                suffixIcon: IconButton(
                                  icon: const Icon(Icons.calendar_today),
                                  onPressed: () => _selectDate(context),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Tanggal lahir tidak boleh kosong';
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: 16),

                            // Baris untuk tinggi dan berat badan
                            Row(
                              children: [
                                // Field tinggi bayi (required) dalam cm
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      RichText(
                                        text: const TextSpan(
                                          children: [
                                            TextSpan(
                                              text: 'Tinggi',
                                              style: TextStyle(
                                                color: AppColors.textBlack,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                                fontFamily: 'Poppins',
                                              ),
                                            ),
                                            TextSpan(
                                              text: '*',
                                              style: TextStyle(
                                                color: Colors.red,
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'Poppins',
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      // Input field untuk tinggi bayi dengan satuan cm
                                      TextFormField(
                                        controller: _heightController,
                                        textInputAction: TextInputAction.next,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                            borderSide: BorderSide(
                                              color: AppColors.componentGrey!,
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                            borderSide: BorderSide(
                                              color: AppColors.componentGrey!,
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                            borderSide: BorderSide(
                                              color: AppColors.componentGrey!,
                                            ),
                                          ),
                                          filled: true,
                                          fillColor: Colors.white,
                                          hintText: '0',
                                          suffixText: 'cm',
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Tinggi tidak boleh kosong';
                                          }
                                          if (double.tryParse(value) == null) {
                                            return 'Tinggi harus berupa angka';
                                          }
                                          return null;
                                        },
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(width: 16),

                                // Field berat bayi (required) dalam kg
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      RichText(
                                        text: const TextSpan(
                                          children: [
                                            TextSpan(
                                              text: 'Berat Badan',
                                              style: TextStyle(
                                                color: AppColors.textBlack,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                                fontFamily: 'Poppins',
                                              ),
                                            ),
                                            TextSpan(
                                              text: '*',
                                              style: TextStyle(
                                                color: Colors.red,
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'Poppins',
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      // Input field untuk berat bayi (mendukung angka desimal)
                                      TextFormField(
                                        controller: _weightController,
                                        textInputAction: TextInputAction.next,
                                        keyboardType:
                                            const TextInputType.numberWithOptions(
                                              decimal: true,
                                            ),
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                            borderSide: BorderSide(
                                              color: AppColors.componentGrey!,
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                            borderSide: BorderSide(
                                              color: AppColors.componentGrey!,
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                            borderSide: BorderSide(
                                              color: AppColors.componentGrey!,
                                            ),
                                          ),
                                          filled: true,
                                          fillColor: Colors.white,
                                          hintText: '0.0',
                                          suffixText: 'kg',
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Berat tidak boleh kosong';
                                          }
                                          if (double.tryParse(value) == null) {
                                            return 'Berat harus berupa angka';
                                          }
                                          return null;
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 16),

                            // Field alergi (opsional)
                            const Text(
                              'Alergi',
                              style: TextStyle(
                                color: AppColors.textBlack,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            // Input field untuk alergi (opsional)
                            TextFormField(
                              controller: _allergyController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: AppColors.componentGrey!,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: AppColors.componentGrey!,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    color: AppColors.componentGrey!,
                                  ),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                hintText: 'Opsional',
                              ),
                              validator: (value) {
                                if (value != null &&
                                    value.isNotEmpty &&
                                    value.length < 3) {
                                  return 'Alergi minimal 3 karakter';
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: 30),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Tombol simpan yang berada di bagian bawah form
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: BlocBuilder<BabyBloc, BabyState>(
                        builder: (context, state) {
                          final isLoading = state is BabyLoading;

                          return ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.accent,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 60,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            onPressed: isLoading ? null : _saveBaby,
                            child: BlocConsumer<BabyBloc, BabyState>(
                              listener: (context, state) {
                                if (state is BabyStored) {
                                  context.read<BabyBloc>().add(FetchBabies());
                                  if (context.mounted) {
                                    Navigator.pop(context);
                                  }
                                  AppFlushbar.showSuccess(
                                    context,
                                    title: 'Berhasil',
                                    message: 'Data bayi berhasil disimpan',
                                    marginVerticalValue: 8,
                                  );
                                } else if (state is BabyError) {
                                  AppFlushbar.showError(
                                    context,
                                    title: 'Error',
                                    message: state.error,
                                  );
                                }
                              },
                              builder: (context, state) {
                                if (state is BabyLoading) {
                                  return const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2.0,
                                    ),
                                  );
                                }

                                return const Text(
                                  'Simpan',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
