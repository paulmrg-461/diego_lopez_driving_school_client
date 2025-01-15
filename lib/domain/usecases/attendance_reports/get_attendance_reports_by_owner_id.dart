// get_attendance_reports_by_owner_id.dart

import 'package:diego_lopez_driving_school_client/data/models/attendance_report_model.dart';
import 'package:diego_lopez_driving_school_client/domain/repositories/attendance_report_repository.dart';

class GetAttendanceReportsByOwnerId {
  final AttendanceReportRepository repository;

  GetAttendanceReportsByOwnerId(this.repository);

  Future<List<AttendanceReportModel>> call(String ownerId) async {
    return await repository.getAttendanceReportsByOwnerId(ownerId);
  }
}
