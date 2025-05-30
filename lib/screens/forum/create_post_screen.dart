// Nama File: create_post_screen.dart
// Deskripsi: File ini adalah halaman untuk membuat postingan baru di forum.
// Dibuat oleh: Firmansyah Pramudia Ariyanto - NIM: 3312301030
// Tanggal: 18 Mei 2025

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutrimpasi/blocs/thread/thread_bloc.dart';
import 'package:nutrimpasi/constants/colors.dart';
import 'package:nutrimpasi/widgets/button.dart';
import 'package:nutrimpasi/widgets/forum_app_bar.dart' show AppBarForum;

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final FocusNode _titleFocusNode = FocusNode();
  final FocusNode _contentFocusNode = FocusNode();

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _titleFocusNode.dispose();
    _contentFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBarForum(
        title: "Buat Postingan",
        showExitButton: true,
        category: '',
      ),
      body: BlocConsumer<ThreadBloc, ThreadState>(
        listener: (context, state) {
          if (state is ThreadStored) {
            Navigator.of(context).pop();

            // _showDialogReportSuccess(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Berhasil menambah thread"),
                backgroundColor: Colors.green,
              ),
            );

            context.read<ThreadBloc>().add(FetchThreads());
          } else if (state is ThreadError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error), backgroundColor: Colors.red),
            );
          }
        },
        builder: (context, state) {
          return Stack(
            alignment: Alignment.center,
            children: [
              // Lapisan utama konten
              Container(
                decoration: BoxDecoration(color: AppColors.primary),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      16,
                      16,
                      16,
                      60,
                    ), // beri ruang bawah untuk tombol
                    child: Center(
                      child: Card(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(16),
                          child: Form(
                            key: formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextFormField(
                                  controller: _titleController,
                                  focusNode: _titleFocusNode,
                                  maxLines: 1,
                                  decoration: InputDecoration(
                                    hintText: 'Judul Postingan',
                                    border: InputBorder.none,
                                  ),
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return 'Judul tidak boleh kosong';
                                    }
                                    if (value.trim().length < 4) {
                                      return 'Judul minimal 4 karakter';
                                    }
                                    return null;
                                  },
                                  onFieldSubmitted: (_) {
                                    _contentFocusNode.requestFocus();
                                  },
                                ),
                                Divider(color: AppColors.greyLight),
                                TextFormField(
                                  controller: _contentController,
                                  focusNode: _contentFocusNode,
                                  maxLines: 15,
                                  decoration: InputDecoration(
                                    hintText:
                                        'Tanyakan sesuatu atau bagikan pengalamanmu di sini...',
                                    border: InputBorder.none,
                                  ),
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return 'Konten tidak boleh kosong';
                                    }
                                    if (value.trim().length < 4) {
                                      return 'Konten minimal 4 karakter';
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Tombol tetap di bawah
              Positioned(
                bottom: 65,
                // left: 0,
                // right: 0,
                child: MediumButton(
                  text: 'Unggah Postingan',
                  onPressed:
                      state is ThreadLoading
                          ? null
                          : () {
                            if (formKey.currentState!.validate()) {
                              final title = _titleController.text.trim();
                              final content = _contentController.text.trim();

                              context.read<ThreadBloc>().add(
                                StoreThreads(title: title, content: content),
                              );

                              _titleController.clear();
                              _contentController.clear();
                            }
                          },
                  loadingIndicator:
                      state is ThreadLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text(
                            'Unggah',
                            style: TextStyle(
                              color: AppColors.textWhite,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
