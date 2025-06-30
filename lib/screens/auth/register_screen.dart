import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutrimpasi/blocs/authentication/authentication_bloc.dart';
import 'package:nutrimpasi/screens/auth/login_screen.dart';
import 'package:nutrimpasi/constants/colors.dart';
import 'package:nutrimpasi/utils/flushbar.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // Controller untuk form
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // Focus Node untuk perpindahan fokus
  final _nameFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _confirmPasswordFocusNode = FocusNode();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameFocusNode.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  void _register(BuildContext context) {
    context.read<AuthenticationBloc>().add(
      RegisterRequested(
        name: _nameController.text,
        email: _emailController.text,
        password: _passwordController.text,
        passwordConfirmation: _confirmPasswordController.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color.fromRGBO(251, 245, 230, 1),
      body: BlocListener<AuthenticationBloc, AuthenticationState>(
        listener: (context, state) {
          if (state is RegistrationSuccess) {
            AppFlushbar.showSuccess(context, message: state.message);

            // Tunggu sebentar lalu navigasi ke login
            Future.delayed(const Duration(seconds: 3), () {
              if (context.mounted) {
                Navigator.pushReplacementNamed(context, '/login');
              }
            });
          } else if (state is AuthenticationError) {
            AppFlushbar.showError(context, message: state.error);
          }
        },
        child: SingleChildScrollView(
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
                  top: size.height * 0.4,
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
                                  onPressed: () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) => const LoginScreen(),
                                      ),
                                    );
                                  },
                                  style: TextButton.styleFrom(
                                    foregroundColor: AppColors.textGrey,
                                  ),
                                  child: const Text(
                                    'Masuk',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 24,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  children: [
                                    TextButton(
                                      onPressed: () {},
                                      style: TextButton.styleFrom(
                                        foregroundColor: AppColors.textBlack,
                                        padding: EdgeInsets.zero,
                                      ),
                                      child: Column(
                                        children: [
                                          const Text(
                                            'Daftar',
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
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          // Formulir pendaftaran
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
                                    controller: _nameController,
                                    focusNode: _nameFocusNode,
                                    textInputAction: TextInputAction.next,
                                    onFieldSubmitted: (_) {
                                      FocusScope.of(
                                        context,
                                      ).requestFocus(_emailFocusNode);
                                    },
                                    decoration: InputDecoration(
                                      labelText: 'Nama',
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
                                        return 'Nama tidak boleh kosong!';
                                      }
                                      if (value.length > 255) {
                                        return 'Nama tidak boleh lebih dari 255 karakter!';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 16),
                                  TextFormField(
                                    controller: _emailController,
                                    focusNode: _emailFocusNode,
                                    textInputAction: TextInputAction.next,
                                    keyboardType: TextInputType.emailAddress,
                                    onFieldSubmitted: (_) {
                                      FocusScope.of(
                                        context,
                                      ).requestFocus(_passwordFocusNode);
                                    },
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
                                      if (value.length > 255) {
                                        return 'Email tidak boleh lebih dari 255 karakter!';
                                      }
                                      if (!RegExp(
                                        r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                                      ).hasMatch(value)) {
                                        return 'Format email tidak valid!';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 16),
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
                                      if (value.length < 8) {
                                        return 'Kata sandi minimal 8 karakter!';
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
                                      labelText: 'Konfirmasi Kata Sandi',
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
                                  const SizedBox(height: 24),
                                  // Tombol daftar
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
                                                      _register(context);
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
                                                    'Daftar',
                                                    style: TextStyle(
                                                      fontFamily: 'Poppins',
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
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
    );
  }
}
