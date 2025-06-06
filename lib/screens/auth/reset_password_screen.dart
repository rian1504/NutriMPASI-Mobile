import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutrimpasi/blocs/authentication/authentication_bloc.dart';
import 'package:nutrimpasi/screens/auth/login_screen.dart';
import 'package:nutrimpasi/screens/auth/register_screen.dart';
import 'package:nutrimpasi/constants/colors.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String token;
  final String email;

  const ResetPasswordScreen({
    super.key,
    required this.token,
    required this.email,
  });

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  // Controller untuk form
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  // Focus Node untuk perpindahan fokus
  final _passwordFocusNode = FocusNode();
  final _confirmPasswordFocusNode = FocusNode();

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  void _resetPassword(BuildContext context) {
    context.read<AuthenticationBloc>().add(
      ResetPasswordRequested(
        token: widget.token,
        email: widget.email,
        password: _passwordController.text,
        passwordConfirmation: _confirmPasswordController.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        if (state is ResetPasswordSuccess) {
          // Tampilkan snackbar sukses dan arahkan ke halaman utama
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));

          // Tunggu sebentar lalu navigasi ke home
          Future.delayed(const Duration(milliseconds: 500), () {
            if (context.mounted) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            }
          });
        } else if (state is AuthenticationError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.error)));
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: AppColors.background,
        body: SingleChildScrollView(
          child: SizedBox(
            height: size.height,
            child: Stack(
              children: [
                // Gambar latar belakang
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: size.height * 1,
                  child: Image.asset(
                    'assets/images/background/reset_kata_sandi.png',
                    fit: BoxFit.cover,
                  ),
                ),
                // Panel utama
                Positioned(
                  top: size.height * 0.5,
                  left: 24,
                  right: 24,
                  child: Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: 24.0,
                        right: 24.0,
                        top: 24.0,
                        bottom:
                            MediaQuery.of(context).viewInsets.bottom > 0
                                ? 24.0 +
                                    MediaQuery.of(context).viewInsets.bottom *
                                        0.5
                                : 24.0,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Tab navigasi
                          const Text(
                            'Reset Kata Sandi',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textBlack,
                            ),
                          ),
                          const SizedBox(height: 24),
                          // Formulir forgot password
                          Form(
                            key: _formKey,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8.0,
                                horizontal: 16,
                              ),
                              child: Column(
                                children: [
                                  TextFormField(
                                    controller: _passwordController,
                                    focusNode: _passwordFocusNode,
                                    textInputAction: TextInputAction.next,
                                    obscureText: _obscurePassword,
                                    onFieldSubmitted: (_) {
                                      FocusScope.of(
                                        context,
                                      ).requestFocus(_confirmPasswordFocusNode);
                                    },
                                    decoration: InputDecoration(
                                      labelText: 'Kata Sandi Baru',
                                      border: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: AppColors.componentGrey!,
                                          width: 1.0,
                                        ),
                                      ),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: AppColors.componentGrey!,
                                          width: 1.0,
                                        ),
                                      ),
                                      focusedBorder: const UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: AppColors.primary,
                                          width: 2.0,
                                        ),
                                      ),
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          _obscurePassword
                                              ? Icons.visibility_off
                                              : Icons.visibility,
                                          color: AppColors.componentGrey!,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _obscurePassword =
                                                !_obscurePassword;
                                          });
                                          _passwordFocusNode.requestFocus();
                                        },
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Kata sandi tidak boleh kosong!';
                                      }
                                      if (value.length < 6) {
                                        return 'Kata sandi minimal 6 karakter!';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 16),
                                  TextFormField(
                                    controller: _confirmPasswordController,
                                    focusNode: _confirmPasswordFocusNode,
                                    textInputAction: TextInputAction.done,
                                    obscureText: _obscureConfirmPassword,
                                    decoration: InputDecoration(
                                      labelText: 'Konfirmasi Kata Sandi Baru',
                                      border: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: AppColors.componentGrey!,
                                          width: 1.0,
                                        ),
                                      ),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: AppColors.componentGrey!,
                                          width: 1.0,
                                        ),
                                      ),
                                      focusedBorder: const UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: AppColors.primary,
                                          width: 2.0,
                                        ),
                                      ),
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          _obscureConfirmPassword
                                              ? Icons.visibility_off
                                              : Icons.visibility,
                                          color: AppColors.componentGrey!,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _obscureConfirmPassword =
                                                !_obscureConfirmPassword;
                                          });
                                          _confirmPasswordFocusNode
                                              .requestFocus();
                                        },
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Konfirmasi kata sandi tidak boleh kosong!';
                                      }
                                      if (value != _passwordController.text) {
                                        return 'Konfirmasi kata sandi tidak sesuai!';
                                      }
                                      return null;
                                    },
                                  ),

                                  const SizedBox(height: 48),

                                  // Tombol kirim
                                  SizedBox(
                                    width: double.infinity,
                                    height: 50,
                                    child: BlocBuilder<
                                      AuthenticationBloc,
                                      AuthenticationState
                                    >(
                                      builder: (context, state) {
                                        final isLoading =
                                            state is AuthenticationLoading;

                                        return ElevatedButton(
                                          onPressed:
                                              isLoading
                                                  ? null
                                                  : () {
                                                    if (_formKey.currentState!
                                                        .validate()) {
                                                      _resetPassword(context);
                                                    }
                                                  },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: AppColors.accent,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                            ),
                                          ),
                                          child:
                                              isLoading
                                                  ? const CircularProgressIndicator(
                                                    color: Colors.white,
                                                  )
                                                  : const Text(
                                                    'Kirim',
                                                    style: TextStyle(
                                                      fontFamily: 'Poppins',
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                        );
                                      },
                                    ),
                                  ),

                                  const SizedBox(height: 16),

                                  // Link kembali ke halaman masuk atau daftar
                                  RichText(
                                    text: TextSpan(
                                      text: 'kembali ke halaman ',
                                      style: TextStyle(
                                        color: AppColors.textBlack,
                                        fontSize: 12,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: 'Masuk',
                                          style: TextStyle(
                                            color: AppColors.accent,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                          recognizer:
                                              TapGestureRecognizer()
                                                ..onTap = () {
                                                  Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder:
                                                          (context) =>
                                                              const LoginScreen(),
                                                    ),
                                                  );
                                                },
                                        ),
                                        TextSpan(
                                          text: ' atau ',
                                          style: TextStyle(
                                            color: AppColors.textBlack,
                                            fontSize: 12,
                                          ),
                                        ),
                                        TextSpan(
                                          text: 'Daftar',
                                          style: TextStyle(
                                            color: AppColors.accent,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                          recognizer:
                                              TapGestureRecognizer()
                                                ..onTap = () {
                                                  Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder:
                                                          (context) =>
                                                              const RegisterScreen(),
                                                    ),
                                                  );
                                                },
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
