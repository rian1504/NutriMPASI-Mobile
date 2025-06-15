import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutrimpasi/blocs/authentication/authentication_bloc.dart';
import 'package:nutrimpasi/constants/colors.dart';
import 'package:nutrimpasi/utils/flushbar.dart';

class PasswordSettingScreen extends StatefulWidget {
  const PasswordSettingScreen({super.key});

  @override
  State<PasswordSettingScreen> createState() => _PasswordSettingScreenState();
}

class _PasswordSettingScreenState extends State<PasswordSettingScreen> {
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
            leading: IconButton(
              icon:
                  state is AuthenticationLoading
                      ? Text('')
                      : Icon(Icons.arrow_back_ios_new_rounded),
              onPressed:
                  state is AuthenticationLoading
                      ? null
                      : () {
                        Navigator.pop(context);
                      },
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
                                  controller: _oldPasswordController,
                                  focusNode: _oldPasswordFocusNode,
                                  textInputAction: TextInputAction.next,
                                  hintText: 'Kata sandi lama',
                                  obscureText: _obscureOldPassword,
                                  prefixIcon: Icons.lock,
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
                                _buildTextField(
                                  controller: _newPasswordController,
                                  focusNode: _newPasswordFocusNode,
                                  textInputAction: TextInputAction.next,
                                  hintText: 'Kata sandi baru',
                                  obscureText: _obscureNewPassword,
                                  prefixIcon: Icons.lock_outlined,
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
                                _buildTextField(
                                  controller:
                                      _newPasswordConfirmationController,
                                  focusNode: _newPasswordConfirmationFocusNode,
                                  textInputAction: TextInputAction.next,
                                  hintText: 'Konfirmasi kata sandi baru',
                                  obscureText: _obscureNewPasswordConfirmation,
                                  prefixIcon: Icons.lock_reset_outlined,
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
                                        // e.g., show an error or log a message.
                                        // For now, you might just do nothing or show a debug print.
                                        debugPrint(
                                          'Error: loggedInUser is null when trying to save password.',
                                        );
                                      }
                                    },
                            child:
                                state is AuthenticationLoading
                                    ? CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                    : Text(
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
      },
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    String? hintText,
    FocusNode? focusNode,
    TextInputAction? textInputAction,
    void Function(String)? onFieldSubmitted,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    bool obscureText = false,
    IconData? prefixIcon,
    IconButton? suffixIcon,
  }) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      textInputAction: textInputAction,
      onFieldSubmitted: onFieldSubmitted,
      keyboardType: keyboardType,
      obscureText: obscureText,
      decoration: InputDecoration(
        prefixIcon:
            prefixIcon != null ? Icon(prefixIcon, color: Colors.black) : null,
        suffixIcon: suffixIcon,
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
