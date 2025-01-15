import 'package:diego_lopez_driving_school_client/data/models/attendance_report_model.dart';
import 'package:diego_lopez_driving_school_client/domain/repositories/attendance_report_repository.dart';

class GetAttendanceReportsByDateRange {
  final AttendanceReportRepository repository;

  GetAttendanceReportsByDateRange(this.repository);

  Future<List<AttendanceReportModel>> call(
    DateTime startDate,
    DateTime endDate,
  ) async {
    return repository.getAttendanceReportsByDateRange(startDate, endDate);
  }
}
