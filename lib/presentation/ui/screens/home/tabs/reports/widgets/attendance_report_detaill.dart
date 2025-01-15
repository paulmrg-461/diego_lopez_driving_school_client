import 'package:diego_lopez_driving_school_client/domain/entities/attendance_report.dart';
import 'package:diego_lopez_driving_school_client/presentation/ui/screens/home/tabs/reports/widgets/large_screen_report.dart';
import 'package:diego_lopez_driving_school_client/presentation/ui/screens/home/tabs/reports/widgets/pdf_generator.dart';
import 'package:diego_lopez_driving_school_client/presentation/ui/screens/home/tabs/reports/widgets/mobile_report.dart';
import 'package:flutter/material.dart';

class AttendanceReportDetail extends StatelessWidget {
  static const String name = 'attendance_report_detail_screen';
  final AttendanceReport report;

  const AttendanceReportDetail({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    final String isSecondVisit = report.isSecondVisit ?? false ? 'Si' : 'No';
    final bool isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${report.licensePlate} - ${report.name} ${report.lastname}',
        ),
      ),
      body: Padding(
        padding: isMobile
            ? const EdgeInsets.symmetric(horizontal: 22)
            : const EdgeInsets.symmetric(horizontal: 2),
        child: isMobile
            ? MobileReport(report: report, isSecondVisit: isSecondVisit)
            : LargeScreenReport(
                report: report,
                isSecondVisit: report.isSecondVisit ?? false,
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if ((report.engineerUsername == null ||
              report.engineerUsername!.isEmpty)) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Para poder generar el documento PDF, el director técnico debe aprobar la revisión.',
                ),
              ),
            );
          } else {
            generatePdf(report);
          }
        },
        child: const Icon(Icons.picture_as_pdf),
      ),
    );
  }
}
