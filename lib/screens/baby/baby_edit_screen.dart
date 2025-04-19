import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:nutrimpasi/constants/colors.dart';
import 'package:nutrimpasi/models/baby_model.dart';
import 'package:intl/intl.dart';

class BabyEditScreen extends StatefulWidget {
  final Baby? baby;
  const BabyEditScreen({super.key, this.baby});

  @override
  State<BabyEditScreen> createState() => _BabyEditScreenState();
}

class _BabyEditScreenState extends State<BabyEditScreen> {
  // Form key untuk validasi input
  final _formKey = GlobalKey<FormState>();

  // Controller untuk field input
  late TextEditingController _nameController;
  late TextEditingController _heightController;
  late TextEditingController _weightController;
  late TextEditingController _allergyController;
  late TextEditingController _birthDateController;

  // Default value untuk jenis kelamin
  String _gender = 'Laki-Laki';
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    // Inisialisasi controller dengan data yang sudah ada (jika ada)
    _nameController = TextEditingController(text: widget.baby?.name ?? '');
    _heightController = TextEditingController(
      text: widget.baby?.height != null ? widget.baby!.height.toString() : '',
    );
    _weightController = TextEditingController(
      text: widget.baby?.weight != null ? widget.baby!.weight.toString() : '',
    );
    _allergyController = TextEditingController(
      text: widget.baby?.allergy ?? '',
    );
    _gender = widget.baby?.gender ?? 'Laki-Laki';
    _selectedDate = widget.baby?.birthDate;

    // Format tanggal untuk tampilan
    final dateStr =
        _selectedDate != null
            ? DateFormat('dd-MM-yyyy').format(_selectedDate!)
            : '';
    _birthDateController = TextEditingController(text: dateStr);
  }

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
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2010),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        // Custom theme untuk date picker
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(primary: AppColors.primary),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _birthDateController.text = DateFormat('dd-MM-yyyy').format(picked);
      });
    }
  }

  /// Fungsi untuk menyimpan data bayi
  void _saveBaby() {
    if (_formKey.currentState!.validate()) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.offWhite,
      // AppBar dengan styling khusus
      appBar: AppBar(
        backgroundColor: Color(0xFFFFE1BE),
        elevation: 0,
        // Tombol kembali dengan styling custom
        leading: IconButton(
          icon: const Icon(Symbols.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
          style: IconButton.styleFrom(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.all(8),
          ),
        ),
        title: const Text(
          'Edit Profil Bayi',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.textBlack,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Background gradient di bagian atas
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 100,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFFFFE1BE),
                    Color(0xFFFFC698),
                    Color(0xFFFFAC84),
                    Color(0xFFFF7F53),
                  ],
                ),
              ),
            ),
          ),

          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  // Avatar bayi dengan efek bulat dan shadow
                  Center(
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        color: AppColors.offWhite,
                        shape: BoxShape.circle,
                      ),
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
                              _gender == 'Laki-Laki'
                                  ? 'assets/images/component/bayi_laki_laki.png'
                                  : 'assets/images/component/bayi_perempuan.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Form container dengan efek shadow
                  Stack(
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
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Nama bayi tidak boleh kosong';
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
                                      value: 'Laki-Laki',
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
                                      value: 'Perempuan',
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
                                            keyboardType: TextInputType.number,
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                borderSide: BorderSide(
                                                  color:
                                                      AppColors.componentGrey!,
                                                ),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                borderSide: BorderSide(
                                                  color:
                                                      AppColors.componentGrey!,
                                                ),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                borderSide: BorderSide(
                                                  color:
                                                      AppColors.componentGrey!,
                                                ),
                                              ),
                                              filled: true,
                                              fillColor: Colors.white,
                                              suffixText: 'cm',
                                            ),
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Tinggi tidak boleh kosong';
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
                                            keyboardType:
                                                const TextInputType.numberWithOptions(
                                                  decimal: true,
                                                ),
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                borderSide: BorderSide(
                                                  color:
                                                      AppColors.componentGrey!,
                                                ),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                borderSide: BorderSide(
                                                  color:
                                                      AppColors.componentGrey!,
                                                ),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                borderSide: BorderSide(
                                                  color:
                                                      AppColors.componentGrey!,
                                                ),
                                              ),
                                              filled: true,
                                              fillColor: Colors.white,
                                            ),
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Berat tidak boleh kosong';
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
                                  ),
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
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.secondary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 60,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            onPressed: _saveBaby,
                            child: const Text(
                              'Simpan',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
