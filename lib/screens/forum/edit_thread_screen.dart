// Nama File: create_post_screen.dart
// Deskripsi: File ini adalah halaman untuk membuat postingan baru di forum.
// Dibuat oleh: Firmansyah Pramudia Ariyanto - NIM: 3312301030
// Tanggal: 18 Mei 2025

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutrimpasi/blocs/comment/comment_bloc.dart';
import 'package:nutrimpasi/blocs/like/like_bloc.dart';
import 'package:nutrimpasi/blocs/thread/thread_bloc.dart';
import 'package:nutrimpasi/constants/colors.dart';
import 'package:nutrimpasi/models/thread.dart';
import 'package:nutrimpasi/utils/flushbar.dart';
import 'package:nutrimpasi/widgets/custom_button.dart';
import 'package:nutrimpasi/widgets/custom_app_bar.dart' show AppBarForum;

class EditThreadScreen extends StatefulWidget {
  final Thread thread;
  const EditThreadScreen({super.key, required this.thread});

  @override
  State<EditThreadScreen> createState() => _EditThreadScreenState();
}

class _EditThreadScreenState extends State<EditThreadScreen> {
  final formKey = GlobalKey<FormState>();
  late TextEditingController _titleController = TextEditingController();
  late TextEditingController _contentController = TextEditingController();
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
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.thread.title);
    _contentController = TextEditingController(text: widget.thread.content);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBarForum(
        title: "Edit Postingan",
        showExitButton: true,
        category: '',
      ),
      body: BlocConsumer<ThreadBloc, ThreadState>(
        listener: (context, state) {
          if (state is ThreadUpdated) {
            Navigator.of(context).pop();

            AppFlushbar.showSuccess(
              context,
              title: 'Berhasil',
              message: 'Berhasil mengubah postingan',
            );

            context.read<ThreadBloc>().add(FetchThreads());
            context.read<LikeBloc>().add(FetchLikes());
            context.read<CommentBloc>().add(
              FetchComments(threadId: widget.thread.id),
            );
          } else if (state is ThreadError) {
            AppFlushbar.showError(
              context,
              title: 'Error',
              message: state.error,
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
                                  textInputAction: TextInputAction.next,
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
                                  maxLines: 30,
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
                bottom: 40,
                // left: 0,
                // right: 0,
                child: MediumButton(
                  text: 'Simpan Perubahan',
                  onPressed:
                      state is ThreadLoading
                          ? null
                          : () {
                            if (formKey.currentState!.validate()) {
                              final threadId = widget.thread.id;
                              final title = _titleController.text.trim();
                              final content = _contentController.text.trim();

                              context.read<ThreadBloc>().add(
                                UpdateThreads(
                                  threadId: threadId,
                                  title: title,
                                  content: content,
                                ),
                              );
                            }
                          },
                  loadingIndicator:
                      state is ThreadLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text(
                            'Simpan Perubahan',
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
