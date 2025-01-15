part of 'attendance_report_bloc.dart';

abstract class AttendanceReportEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class CreateAttendanceReportEvent extends AttendanceReportEvent {
  final AttendanceReportModel report;
  final Uint8List signatureBytes;
  final Uint8List attendanceStateBytes;

  CreateAttendanceReportEvent(
      this.report, this.signatureBytes, this.attendanceStateBytes);

  @override
  List<Object?> get props => [report, signatureBytes, attendanceStateBytes];
}

class GetAttendanceReportsByDateRangeEvent extends AttendanceReportEvent {
  final DateTime startDate;
  final DateTime endDate;

  GetAttendanceReportsByDateRangeEvent({
    required this.startDate,
    required this.endDate,
  });

  @override
  List<Object?> get props => [startDate, endDate];
}

class CheckLicensePlateEvent extends AttendanceReportEvent {
  final String licensePlate;

  CheckLicensePlateEvent(this.licensePlate);

  @override
  List<Object?> get props => [licensePlate];
}

class GetAttendanceReportsByOwnerIdEvent extends AttendanceReportEvent {
  final String ownerId;

  GetAttendanceReportsByOwnerIdEvent(this.ownerId);

  @override
  List<Object?> get props => [ownerId];
}
