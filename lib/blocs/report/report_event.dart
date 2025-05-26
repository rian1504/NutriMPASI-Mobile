part of 'report_bloc.dart';

@immutable
sealed class ReportEvent {}

class Report extends ReportEvent {
  final String category;
  final int refersId;
  final String content;

  Report({
    required this.category,
    required this.refersId,
    required this.content,
  });
}
