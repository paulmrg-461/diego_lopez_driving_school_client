import 'package:diego_lopez_driving_school_client/core/helpers/human_formats.dart';
import 'package:diego_lopez_driving_school_client/domain/entities/attendance_report.dart';
import 'package:diego_lopez_driving_school_client/presentation/ui/screens/home/tabs/reports/widgets/attendance_report_detaill.dart';
import 'package:diego_lopez_driving_school_client/presentation/ui/widgets/trailing_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AttendanceReportCard extends StatelessWidget {
  const AttendanceReportCard({super.key, required this.report});

  final AttendanceReport report;

  @override
  Widget build(BuildContext context) {
    final String isSecondVisit = report.isSecondVisit ?? false ? 'Si' : 'No';
    return Container(
      padding: const EdgeInsets.all(18),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        // border: Border.all()
      ),
      child: InkWell(
        onTap: () =>
            context.pushNamed(AttendanceReportDetail.name, extra: report),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${report.name} ${report.lastname}',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 4),
                    TrailingWidget(
                      text:
                          '${report.licensePlate}: ${report.brand} ${report.color} - ${report.year}',
                      icon: Icons.delivery_dining_outlined,
                    ),
                    TrailingWidget(
                      text: 'Servicio: ${report.serviceType}',
                      icon: Icons.delivery_dining_outlined,
                    ),
                    TrailingWidget(
                      text:
                          '${report.documentType ?? ''} - ${report.documentNumber ?? ''}',
                      icon: Icons.person_2_outlined,
                    ),
                    TrailingWidget(
                      text: report.email,
                      icon: Icons.email_outlined,
                    ),
                    TrailingWidget(
                      text: report.address,
                      icon: Icons.location_on_outlined,
                    ),
                    TrailingWidget(
                      text: report.phone,
                      icon: Icons.phone_outlined,
                    ),
                    TrailingWidget(
                      text: "Segunda visita: $isSecondVisit",
                      icon: Icons.info_outline_rounded,
                    ),
                  ],
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TrailingWidget(
                  text: HumanFormats.convertDate(report.createdAt),
                  icon: Icons.date_range_outlined,
                ),
                TrailingWidget(
                  text: HumanFormats.convertTime(report.createdAt),
                  icon: Icons.access_time,
                ),
                TrailingWidget(
                  text:
                      '${HumanFormats.formatWithThousandsSeparator(report.mileage.toString())} Km',
                  icon: Icons.speed_outlined,
                ),
                TrailingWidget(
                  icon: Icons.tire_repair_outlined,
                  text:
                      'D: ${report.frontPressure ?? 0} - T: ${report.rearPressure ?? 0}',
                ),
                TrailingWidget(
                  icon: Icons.new_releases_outlined,
                  text: report.year ?? '',
                ),
                TrailingWidget(
                  icon: Icons.personal_injury_outlined,
                  text: report.operatorUsername ?? '',
                ),
                TrailingWidget(
                  icon: Icons.engineering_outlined,
                  text: report.engineerUsername == null ||
                          report.engineerUsername!.isEmpty
                      ? 'Pendiente'
                      : report.engineerUsername!,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
