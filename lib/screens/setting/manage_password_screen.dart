import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutrimpasi/blocs/authentication/authentication_bloc.dart';
import 'package:nutrimpasi/constants/colors.dart';
import 'package:nutrimpasi/utils/flushbar.dart';

class ManageSettingScreen extends StatefulWidget {
  const ManageSettingScreen({super.key});

  @override
  State<ManageSettingScreen> createState() => _ManageSettingScreenState();
}

class _ManageSettingScreenState extends State<ManageSettingScreen> {
  // Controller untuk form
  final _formKey = GlobalKey<FormState>();
  bool _obscureOldPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureNewPasswordConfirmation = true;
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _newPasswordConfirmationController =
      TextEditingController();

  // Focus Node untuk perpindahan fokus
  final _oldPasswordFocusNode = FocusNode();
  final _newPasswordFocusNode = FocusNode();
  final _newPasswordConfirmationFocusNode = FocusNode();

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _newPasswordConfirmationController.dispose();
    _oldPasswordFocusNode.dispose();
    _newPasswordFocusNode.dispose();
    _newPasswordConfirmationFocusNode.dispose();
    super.dispose();
  }

  void _savePassword({required int userId}) {
    if (_formKey.currentState!.validate()) {
      context.read<AuthenticationBloc>().add(
        UpdatePassword(
          userId: userId,
          oldPassword: _oldPasswordController.text,
          newPassword: _newPasswordController.text,
          newPasswordConfirmation: _newPasswordConfirmationController.text,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Dapatkan data user dari authentication bloc
    final authState = context.watch<AuthenticationBloc>().state;
    final loggedInUser = authState is LoginSuccess ? authState.user : null;

    return BlocConsumer<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        if (state is PasswordUpdated) {
          Navigator.pop(context);
          AppFlushbar.showSuccess(
            context,
            message: "Password berhasil diperbarui!",
            title: "Berhasil",
            position: FlushbarPosition.BOTTOM,
          );
        } else if (state is ProfileError) {
          AppFlushbar.showError(
            context,
            message: state.error,
            title: "Gagal",
            position: FlushbarPosition.BOTTOM,
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.primary,
            elevation: 0,
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
                    icon:
                        state is AuthenticationLoading
                            ? Container()
                            : const Icon(
                              Icons.arrow_back_ios_new_rounded,
                              color: AppColors.textBlack,
                              size: 24,
                            ),
                    onPressed:
                        state is AuthenticationLoading
                            ? null
                            : () {
                              Navigator.pop(context);
                            },
                    padding: EdgeInsets.zero,
                  ),
                ),
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

                    // Icon kunci di tengah lingkaran
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
                          child: const Icon(
                            Icons.lock,
                            size: 80,
                            color: AppColors.accent,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 100),

                // Konten utama untuk form
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Field password lama
                                RichText(
                                  text: const TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'Kata Sandi Lama',
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
                                TextFormField(
                                  controller: _oldPasswordController,
                                  focusNode: _oldPasswordFocusNode,
                                  textInputAction: TextInputAction.next,
                                  obscureText: _obscureOldPassword,
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
                                    hintText: 'Kata sandi lama',
                                    prefixIcon: const Icon(
                                      Icons.lock,
                                      color: Colors.black,
                                    ),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _obscureOldPassword
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                        color: AppColors.componentGrey!,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _obscureOldPassword =
                                              !_obscureOldPassword;
                                        });
                                        _oldPasswordFocusNode.requestFocus();
                                      },
                                    ),
                                  ),
                                  onFieldSubmitted: (_) {
                                    FocusScope.of(
                                      context,
                                    ).requestFocus(_newPasswordFocusNode);
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Kata sandi lama tidak boleh kosong';
                                    }
                                    if (value.length < 8) {
                                      return 'Minimal 8 karakter';
                                    }
                                    return null;
                                  },
                                ),

                                const SizedBox(height: 16),

                                // Field password baru
                                RichText(
                                  text: const TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'Kata Sandi Baru',
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
                                TextFormField(
                                  controller: _newPasswordController,
                                  focusNode: _newPasswordFocusNode,
                                  textInputAction: TextInputAction.next,
                                  obscureText: _obscureNewPassword,
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
                                    hintText: 'Kata sandi baru',
                                    prefixIcon: const Icon(
                                      Icons.lock_outlined,
                                      color: Colors.black,
                                    ),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _obscureNewPassword
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                        color: AppColors.componentGrey!,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _obscureNewPassword =
                                              !_obscureNewPassword;
                                        });
                                        _newPasswordFocusNode.requestFocus();
                                      },
                                    ),
                                  ),
                                  onFieldSubmitted: (_) {
                                    FocusScope.of(context).requestFocus(
                                      _newPasswordConfirmationFocusNode,
                                    );
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Kata sandi baru tidak boleh kosong';
                                    }
                                    if (value.length < 8) {
                                      return 'Minimal 8 karakter';
                                    }
                                    return null;
                                  },
                                ),

                                const SizedBox(height: 16),

                                // Field konfirmasi password baru
                                RichText(
                                  text: const TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'Konfirmasi Kata Sandi Baru',
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
                                TextFormField(
                                  controller:
                                      _newPasswordConfirmationController,
                                  focusNode: _newPasswordConfirmationFocusNode,
                                  textInputAction: TextInputAction.done,
                                  obscureText: _obscureNewPasswordConfirmation,
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
                                    hintText: 'Konfirmasi kata sandi baru',
                                    prefixIcon: const Icon(
                                      Icons.lock_reset_outlined,
                                      color: Colors.black,
                                    ),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _obscureNewPasswordConfirmation
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                        color: AppColors.componentGrey!,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _obscureNewPasswordConfirmation =
                                              !_obscureNewPasswordConfirmation;
                                        });
                                        _newPasswordConfirmationFocusNode
                                            .requestFocus();
                                      },
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Harap konfirmasi kata sandi baru';
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
                      // Tombol simpan di bagian bawah form
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
                            onPressed:
                                state is AuthenticationLoading
                                    ? null
                                    : () {
                                      if (loggedInUser != null) {
                                        // Add a null check for loggedInUser
                                        _savePassword(userId: loggedInUser.id);
                                      } else {
                                        // Handle the case where loggedInUser is null,
                                        debugPrint(
                                          'Error: loggedInUser is null when trying to save password.',
                                        );
                                      }
                                    },
                            child:
                                state is AuthenticationLoading
                                    ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2.0,
                                      ),
                                    )
                                    : const Text(
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

                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }
}
