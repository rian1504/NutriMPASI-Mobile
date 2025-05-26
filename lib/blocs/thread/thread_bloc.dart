import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutrimpasi/controllers/thread_controller.dart';
import 'package:nutrimpasi/models/thread.dart';

part 'thread_event.dart';
part 'thread_state.dart';

class ThreadBloc extends Bloc<ThreadEvent, ThreadState> {
  final ThreadController controller;

  ThreadBloc({required this.controller}) : super(ThreadInitial()) {
    on<FetchThreads>(_onFetch);
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
