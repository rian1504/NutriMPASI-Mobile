import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutrimpasi/controllers/like_controller.dart';
import 'package:nutrimpasi/controllers/thread_controller.dart';
import 'package:nutrimpasi/models/thread.dart';

part 'thread_event.dart';
part 'thread_state.dart';

class ThreadBloc extends Bloc<ThreadEvent, ThreadState> {
  final ThreadController controller;
  final LikeController likeController;

  ThreadBloc({required this.controller, required this.likeController})
    : super(ThreadInitial()) {
    on<FetchThreads>(_onFetch);
    on<ToggleLike>(_onToggleLike);
    on<StoreThreads>(_onStore);
    on<UpdateThreads>(_onUpdate);
    on<DeleteThreads>(_onDelete);
  }

  Future<void> _onFetch(FetchThreads event, Emitter<ThreadState> emit) async {
    emit(ThreadLoading());
    try {
      final result = await controller.getThread();
      emit(ThreadLoaded(threads: result));
    } catch (e) {
      emit(ThreadError('Fetch Thread gagal: ${e.toString()}'));
    }
  }

  Future<void> _onToggleLike(
    ToggleLike event,
    Emitter<ThreadState> emit,
  ) async {
    if (state is! ThreadLoaded) return;
    final currentState = state as ThreadLoaded;
    final threads = currentState.threads;

    try {
      // Cari thread yang akan di-update
      final threadIndex = threads.indexWhere((t) => t.id == event.threadId);
      if (threadIndex == -1) return; // Thread tidak ditemukan

      final thread = threads[threadIndex];

      // Optimistic Update: Update UI sebelum API call
      final updatedThread = thread.copyWith(
        isLike: !thread.isLike, // Toggle isLike (true ↔ false)
        likesCount:
            thread.isLike
                ? thread.likesCount - 1
                : thread.likesCount + 1, // Update jumlah like
      );

      // Buat list baru dengan thread yang di-update
      final updatedThreads = List<Thread>.from(threads);
      updatedThreads[threadIndex] = updatedThread;

      // Update UI
      emit(ThreadLoaded(threads: updatedThreads));

      // Kirim request ke API
      await likeController.toggleLike(threadId: event.threadId);
    } catch (e) {
      emit(ThreadError('Gagal mengupdate like: ${e.toString()}'));
      emit(currentState);
    }
  }

  Future<void> _onStore(StoreThreads event, Emitter<ThreadState> emit) async {
    emit(ThreadLoading());
    try {
      await controller.storeThread(title: event.title, content: event.content);

      emit(ThreadStored());
    } catch (e) {
      emit(ThreadError('Store Thread gagal: ${e.toString()}'));
    }
  }

  Future<void> _onUpdate(UpdateThreads event, Emitter<ThreadState> emit) async {
    emit(ThreadLoading());
    try {
      await controller.updateThread(
        threadId: event.threadId,
        title: event.title,
        content: event.content,
      );
      emit(ThreadUpdated());
    } catch (e) {
      emit(ThreadError('Update Thread gagal: ${e.toString()}'));
    }
  }

  Future<void> _onDelete(DeleteThreads event, Emitter<ThreadState> emit) async {
    emit(ThreadLoading());
    try {
      await controller.deleteThread(threadId: event.threadId);

      emit(ThreadDeleted());
    } catch (e) {
      emit(ThreadError('Delete Thread gagal: ${e.toString()}'));
    }
  }
}
