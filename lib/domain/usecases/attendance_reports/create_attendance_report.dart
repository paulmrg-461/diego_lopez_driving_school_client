import 'package:diego_lopez_driving_school_client/data/models/attendance_report_model.dart';
import 'package:diego_lopez_driving_school_client/domain/repositories/attendance_report_repository.dart';

class CreateAttendanceReport {
  final AttendanceReportRepository repository;

  CreateAttendanceReport(this.repository);

  Future<void> call(AttendanceReportModel report) {
    return repository.createAttendanceReport(report);
  }
}
