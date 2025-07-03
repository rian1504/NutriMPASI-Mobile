// ignore_for_file: unused_field

import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nutrimpasi/blocs/authentication/authentication_bloc.dart';
import 'package:nutrimpasi/constants/colors.dart';
import 'package:nutrimpasi/constants/url.dart';
import 'package:nutrimpasi/models/user.dart';
import 'package:nutrimpasi/utils/flushbar.dart';

class ManageProfileScreen extends StatefulWidget {
  final User? user;
  const ManageProfileScreen({super.key, this.user});

  @override
  State<ManageProfileScreen> createState() => _ManageProfileScreenState();
}

class _ManageProfileScreenState extends State<ManageProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();

    // Inisialisasi controller dengan data yang sudah ada (jika ada)
    _nameController = TextEditingController(text: widget.user?.name ?? '');
    _emailController = TextEditingController(text: widget.user?.email ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      // Validasi ukuran gambar jika ada gambar baru
      if (_imageFile != null) {
        final fileSize = _imageFile!.lengthSync();
        final fileSizeInMB = fileSize / (1024 * 1024);
        if (fileSizeInMB > 1) {
          setState(() {
            _showImageSizeError = true;
          });
          return;
        }
      }

      context.read<AuthenticationBloc>().add(
        UpdateProfile(
          userId: widget.user!.id,
          name: _nameController.text,
          email: _emailController.text,
          avatar: _imageFile,
        ),
      );
    }
  }

  String? _imagePath;
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  // Tambah state untuk melacak error validasi foto
  bool _showPhotoError = false;
  bool _showImageSizeError = false;

  // Menambahkan global key untuk navigasi otomatis ke error
  final GlobalKey _photoFieldKey = GlobalKey();

  // Method untuk memilih foto dari gallery
  Future<void> _getImageFromGallery() async {
    try {
      final XFile? selectedImage = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 50,
      );
      if (selectedImage != null) {
        setState(() {
          _imageFile = File(selectedImage.path);
          _imagePath = selectedImage.path;
        });
      }
    } catch (e) {
      if (!mounted) return;
      AppFlushbar.showError(
        context,
        title: 'Error',
        message: 'Gagal mengakses galeri. Coba periksa izin aplikasi.',
      );
    }
  }

  // Method untuk mengambil foto dari kamera
  Future<void> _getImageFromCamera() async {
    try {
      final XFile? takenImage = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 50,
      );
      if (takenImage != null) {
        setState(() {
          _imageFile = File(takenImage.path);
          _imagePath = takenImage.path;
          _showPhotoError = false;
          _showImageSizeError = false;
        });
      }
    } catch (e) {
      if (!mounted) return;
      AppFlushbar.showError(
        context,
        title: 'Error',
        message: 'Gagal mengakses kamera. Coba periksa izin aplikasi.',
      );
    }
  }

  // Method untuk menampilkan bottom sheet pilihan foto
  void _showImageSourceOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Pilih Sumber Foto',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textBlack,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Tombol opsi kamera
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                      _getImageFromCamera();
                    },
                    child: Column(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: AppColors.buff,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            size: 30,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Kamera',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Tombol opsi galeri
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                      _getImageFromGallery();
                    },
                    child: Column(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: AppColors.buff,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.photo_library,
                            size: 30,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Galeri',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        if (state is ProfileUpdated) {
          Navigator.pop(context);
          AppFlushbar.showSuccess(
            context,
            message: "Profil berhasil diperbarui!",
            title: "Berhasil",
            position: FlushbarPosition.BOTTOM,
            marginVerticalValue: 8,
          );
        } else if (state is ProfileError) {
          AppFlushbar.showError(context, message: state.error, title: "Error");
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
            title: Text(
              'Pengaturan Profil',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            centerTitle: true,
          ),
          body: Stack(
            children: [
              // Background
              Column(
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
                  const SizedBox(height: 100),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _buildTextFieldWithIcon(
                                        controller: _nameController,
                                        icon: Icons.portrait_outlined,
                                        labelText: 'Ganti nama akun',
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Nama tidak boleh kosong';
                                          }
                                          if (value.length < 4) {
                                            return 'Nama minimal 4 karakter';
                                          }
                                          if (value.length > 255) {
                                            return 'Nama maksimal 255 karakter';
                                          }
                                          return null;
                                        },
                                      ),
                                      const SizedBox(height: 16),
                                      _buildTextFieldWithIcon(
                                        controller: _emailController,
                                        icon: Icons.email_outlined,
                                        labelText: 'Ubah alamat email',
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Email tidak boleh kosong';
                                          }
                                          if (!RegExp(
                                            r'^[^@]+@[^@]+\.[^@]+',
                                          ).hasMatch(value)) {
                                            return 'Masukkan email yang valid';
                                          }
                                          return null;
                                        },
                                      ),
                                      const SizedBox(height: 50),
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
                                          : _saveProfile,
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
                    ),
                  ),
                ],
              ),

              // Foto Profil + Kamera
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: _buildProfilePictureWithCamera(),
              ),
            ],
          ),
        );
      },
    );
  }

  // Fungsi untuk membangun widget foto profil dengan kamera
  Widget _buildProfilePictureWithCamera() {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Circle background (orange circle)
        Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(10),
                offset: const Offset(0, 8),
                blurRadius: 0,
                spreadRadius: 0,
              ),
            ],
          ),
        ),

        // Container utama untuk foto profil
        Container(
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
          child:
              _imageFile != null
                  ? ClipOval(
                    child: Image.file(
                      _imageFile!,
                      width: 150,
                      height: 150,
                      fit: BoxFit.cover,
                    ),
                  )
                  : widget.user!.avatar != null
                  ? ClipOval(
                    child: Image.network(
                      storageUrl + widget.user!.avatar!,
                      width: 150,
                      height: 150,
                      fit: BoxFit.cover,
                    ),
                  )
                  : const Icon(
                    Icons.person,
                    size: 100,
                    color: AppColors.accent,
                  ),
        ),

        // Tombol kamera
        Positioned(left: 150, right: 0, top: 85, child: _buildCameraButton()),
      ],
    );
  }

  // Fungsi untuk membangun tombol kamera
  Widget _buildCameraButton() {
    return Material(
      color: Colors.transparent,
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          _showImageSourceOptions();
        },
        splashColor: Colors.grey.withAlpha(75),
        highlightColor: Colors.grey.withAlpha(25),
        child: Container(
          width: 40,
          height: 40,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(color: Colors.black26, blurRadius: 4, spreadRadius: 1),
            ],
          ),
          child: const Icon(
            Icons.camera_alt_rounded,
            size: 20,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }

  Widget _buildTextFieldWithIcon({
    required TextEditingController controller,
    required IconData icon,
    String? labelText,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.black),
        labelText: labelText,
        labelStyle: const TextStyle(color: Colors.grey, fontSize: 14),
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
      ),
      validator: validator,
    );
  }
}
