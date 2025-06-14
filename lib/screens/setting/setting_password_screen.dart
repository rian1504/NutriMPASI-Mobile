import 'package:flutter/material.dart';
import 'package:nutrimpasi/constants/colors.dart';

class PasswordSettingScreen extends StatefulWidget {
  const PasswordSettingScreen({super.key});

  @override
  State<PasswordSettingScreen> createState() => _PasswordSettingScreenState();
}

class _PasswordSettingScreenState extends State<PasswordSettingScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _savePassword() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Kata sandi berhasil diperbarui!'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
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
          'Kelola Kata Sandi',
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
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primary,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(10),
                            offset: const Offset(0, 8),
                            blurRadius: 0,
                            spreadRadius: 0,
                          ),
                        ],
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
                          child: const Icon(
                            Icons.lock_rounded,
                            size: 100,
                            color: AppColors.accent,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 100),
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
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            _buildTextField(
                              controller: _newPasswordController,
                              hintText: 'Kata sandi baru',
                              obscureText: true,
                              prefixIcon: Icons.lock_outlined,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Kata sandi tidak boleh kosong';
                                }
                                if (value.length < 6) {
                                  return 'Minimal 6 karakter';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            _buildTextField(
                              controller: _confirmPasswordController,
                              hintText: 'Konfirmasi kata sandi',
                              obscureText: true,
                              prefixIcon: Icons.lock_reset_outlined,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Harap konfirmasi kata sandi';
                                }
                                if (value != _newPasswordController.text) {
                                  return 'Konfirmasi tidak cocok';
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
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: ElevatedButton(
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
                        onPressed: _savePassword,
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    String? hintText,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    bool obscureText = false,
    IconData? prefixIcon,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      decoration: InputDecoration(
        prefixIcon:
            prefixIcon != null ? Icon(prefixIcon, color: Colors.black) : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppColors.componentGrey ?? Colors.grey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppColors.componentGrey ?? Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppColors.componentGrey ?? Colors.grey),
        ),
        filled: true,
        fillColor: Colors.white,
        hintText: hintText,
      ),
      validator: validator,
    );
  }
}
