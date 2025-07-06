import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutrimpasi/blocs/authentication/authentication_bloc.dart';
import 'package:nutrimpasi/screens/auth/forget_password_screen.dart';
import 'package:nutrimpasi/screens/auth/register_screen.dart';
import 'package:nutrimpasi/constants/colors.dart';
import 'package:nutrimpasi/utils/flushbar.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Controller untuk form
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login(BuildContext context) {
    context.read<AuthenticationBloc>().add(
      LoginRequested(
        email: _emailController.text,
        password: _passwordController.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.background,
      body: BlocListener<AuthenticationBloc, AuthenticationState>(
        listener: (context, state) {
          if (state is LoginSuccess) {
            if (context.mounted) {
              Navigator.pushReplacementNamed(context, '/home');
            }
            AppFlushbar.showNormal(
              context,
              title: "Selamat datang mama!",
              message: state.message ?? 'Login berhasil',
            );
          } else if (state is AuthenticationError) {
            AppFlushbar.showError(context, message: state.error);
          }
        },
        child: SingleChildScrollView(
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
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
                      'assets/images/background/auth.png',
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
                            Row(
                              children: [
                                Expanded(
                                  child: TextButton(
                                    onPressed: () {},
                                    style: TextButton.styleFrom(
                                      foregroundColor: AppColors.textBlack,
                                    ),
                                    child: Column(
                                      children: [
                                        const Text(
                                          'Masuk',
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 24,
                                            fontWeight: FontWeight.w900,
                                          ),
                                        ),
                                        Container(
                                          width: 70,
                                          height: 2,
                                          color: AppColors.textBlack,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: TextButton(
                                    onPressed: () {
                                      Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (context) =>
                                                  const RegisterScreen(),
                                        ),
                                        (route) => false,
                                      );
                                    },
                                    style: TextButton.styleFrom(
                                      foregroundColor: AppColors.textGrey,
                                    ),
                                    child: const Text(
                                      'Daftar',
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 24,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
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
                                        focusedBorder:
                                            const UnderlineInputBorder(
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
                                    const SizedBox(height: 16),
                                    TextFormField(
                                      controller: _passwordController,
                                      textInputAction: TextInputAction.done,
                                      obscureText: _obscurePassword,
                                      decoration: InputDecoration(
                                        labelText: 'Kata Sandi',
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
                                        focusedBorder:
                                            const UnderlineInputBorder(
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
                                          },
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Kata Sandi tidak boleh kosong!';
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 8),
                                    // Link lupa password
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: TextButton(
                                        onPressed: () {
                                          Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(
                                              builder:
                                                  (context) =>
                                                      const ForgetPasswordScreen(),
                                            ),
                                            (route) => false,
                                          );
                                        },
                                        child: const Text(
                                          'Lupa Kata Sandi?',
                                          style: TextStyle(
                                            color: AppColors.accent,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 24),
                                    // Tombol masuk
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
                                                      FocusScope.of(
                                                        context,
                                                      ).unfocus();
                                                      if (_formKey.currentState!
                                                          .validate()) {
                                                        _login(context);
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
                                                      'Masuk',
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
      ),
    );
  }
}
