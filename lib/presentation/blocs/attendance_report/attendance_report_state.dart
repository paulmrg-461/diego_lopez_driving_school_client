part of 'attendance_report_bloc.dart';

abstract class AttendanceReportState extends Equatable {
  @override
  List<Object?> get props => [];
}

final class AttendanceReportInitial extends AttendanceReportState {}

class AttendanceReportLoading extends AttendanceReportState {}

class AttendanceReportLoaded extends AttendanceReportState {}

class AttendanceReportFailure extends AttendanceReportState {
  final String message;

  AttendanceReportFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class AttendanceReportSuccess extends AttendanceReportState {
  final List<AttendanceReportModel> reports;

  AttendanceReportSuccess(this.reports);

  @override
  List<Object?> get props => [reports];
}

class AttendanceReportPreFillState extends AttendanceReportState {
  final AttendanceReportModel report;

  AttendanceReportPreFillState(this.report);

  @override
  List<Object?> get props => [report];
}

class AttendanceReportOwnerReportsSuccess extends AttendanceReportState {
  final List<AttendanceReportModel> reports;

  AttendanceReportOwnerReportsSuccess(this.reports);

  @override
  List<Object?> get props => [reports];
}
