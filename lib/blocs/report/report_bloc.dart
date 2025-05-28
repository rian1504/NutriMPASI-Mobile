import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutrimpasi/controllers/report_controller.dart';

part 'report_event.dart';
part 'report_state.dart';

class ReportBloc extends Bloc<ReportEvent, ReportState> {
  final ReportController controller;

  ReportBloc({required this.controller}) : super(ReportInitial()) {
    on<Report>(_onReport);
  }

  Future<void> _onReport(Report event, Emitter<ReportState> emit) async {
    emit(ReportLoading());
    try {
      await controller.storeReport(
        category: event.category,
        refersId: event.refersId,
        content: event.content,
      );
      emit(ReportSuccess());

      // // Jika ingin kembali ke state sebelumnya setelah beberapa detik
      // await Future.delayed(const Duration(seconds: 2));
      // if (state is FoodReportSuccess) {
      //   emit(ReportLoaded(food: (state as ReportLoaded).food));
      // }
    } catch (e) {
      emit(ReportError('Gagal melaporkan: ${e.toString()}'));

      // // Kembali ke state sebelumnya setelah beberapa detik
      // await Future.delayed(const Duration(seconds: 2));
      // if (state is FoodReportError) {
      //   emit(ReportLoaded(food: (state as ReportLoaded).food));
      // }
    }
  }
}
