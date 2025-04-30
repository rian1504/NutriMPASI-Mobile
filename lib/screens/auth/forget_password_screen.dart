import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutrimpasi/blocs/authentication/authentication_bloc.dart';
import 'package:nutrimpasi/screens/auth/login_screen.dart';
import 'package:nutrimpasi/screens/auth/register_screen.dart';
import 'package:nutrimpasi/constants/colors.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  // Controller untuk form
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _forgotPassword(BuildContext context) {
    context.read<AuthenticationBloc>().add(
      ForgotPasswordRequested(email: _emailController.text),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        if (state is ForgotPasswordSuccess) {
          // Tampilkan snackbar sukses dan arahkan ke halaman utama
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));

          // Tunggu sebentar lalu navigasi ke home
          Future.delayed(const Duration(milliseconds: 500), () {
            Navigator.pushReplacementNamed(context, '/home');
          });
        } else if (state is AuthenticationError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.error)));
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: AppColors.pearl,
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
                    'assets/images/background/lupa_kata_sandi.png',
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
                            'Lupa Kata Sandi',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textBlack,
                            ),
                          ),
                          const Text(
                            'Silahkan masukkan email yang sebelumnya terdaftar, link reset kata sandi baru akan dikirim ke emailmu',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 12,
                              color: AppColors.textGrey,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 24),
                          // Formulir login
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
                                    controller: _emailController,
                                    textInputAction: TextInputAction.next,
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: InputDecoration(
                                      labelText: 'Email',
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
                                    ),

                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Email tidak boleh kosong!';
                                      }
                                      return null;
                                    },
                                  ),

                                  const SizedBox(height: 48),

                                  // Tombol masuk
                                  SizedBox(
                                    width: double.infinity,
                                    height: 50,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        // Validasi dan navigasi
                                        if (_formKey.currentState!.validate()) {
                                          _forgotPassword(context);
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.secondary,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            30,
                                          ),
                                        ),
                                      ),
                                      child: BlocBuilder<
                                        AuthenticationBloc,
                                        AuthenticationState
                                      >(
                                        builder: (context, state) {
                                          if (state is AuthenticationLoading) {
                                            return const CircularProgressIndicator();
                                          }
                                          return const Text(
                                            'Kirim',
                                            style: TextStyle(
                                              fontFamily: 'Poppins',
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white,
                                            ),
                                          );
                                        },
                                      ),
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
                                            color: AppColors.secondary,
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
                                            color: AppColors.secondary,
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
