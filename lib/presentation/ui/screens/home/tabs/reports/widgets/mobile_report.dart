import 'package:diego_lopez_driving_school_client/core/helpers/human_formats.dart';
import 'package:diego_lopez_driving_school_client/domain/entities/attendance_report.dart';
import 'package:diego_lopez_driving_school_client/presentation/ui/screens/home/tabs/reports/widgets/personal_data_processing_widget.dart';
import 'package:diego_lopez_driving_school_client/presentation/ui/screens/attendance_register_form/widgets/contractual_conditions.dart';
import 'package:diego_lopez_driving_school_client/presentation/ui/widgets/image_with_builder.dart';
import 'package:diego_lopez_driving_school_client/presentation/ui/widgets/trailing_widget.dart';
import 'package:flutter/material.dart';

class MobileReport extends StatelessWidget {
  const MobileReport({
    super.key,
    required this.report,
    required this.isSecondVisit,
  });

  final AttendanceReport report;
  final String isSecondVisit;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return ListView(
      children: [
        ExpansionTile(
          initiallyExpanded: true,
          expandedAlignment: Alignment.centerLeft,
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          childrenPadding: const EdgeInsets.all(16),
          title: Text(
            'Datos de la visita',
            style: Theme.of(context).textTheme.titleMedium,
          ),
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
              text: "Segunda visita: $isSecondVisit",
              icon: Icons.info_outline_rounded,
            ),
            TrailingWidget(
              text: report.engineerUsername == null ||
                      report.engineerUsername!.isEmpty
                  ? 'Revisión Pendiente por Ingeniero'
                  : 'Aprobado por Ing. ${report.engineerUsername}',
              icon: Icons.info_outline_rounded,
            ),
          ],
        ),
        ExpansionTile(
          initiallyExpanded: true,
          expandedAlignment: Alignment.centerLeft,
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          childrenPadding: const EdgeInsets.all(16),
          title: Text(
            'Datos del vehiculo',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          children: [
            TrailingWidget(
              text: report.licensePlate,
              icon: Icons.delivery_dining_outlined,
            ),
            TrailingWidget(
              text: report.brand,
              icon: Icons.delivery_dining_outlined,
            ),
            TrailingWidget(
              text: report.year ?? '',
              icon: Icons.calendar_month_outlined,
            ),
            TrailingWidget(text: report.color, icon: Icons.color_lens_outlined),
            TrailingWidget(
              text: report.serviceType,
              icon: Icons.delivery_dining_outlined,
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
              icon: Icons.description_outlined,
              text: report.observations,
            ),
            const Divider(),
            ImageWithBuilder(
              imageUrl: report.attendanceStateImageUrl,
              width: screenWidth,
            ),
          ],
        ),
        ExpansionTile(
          initiallyExpanded: true,
          expandedAlignment: Alignment.centerLeft,
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          childrenPadding: const EdgeInsets.all(16),
          title: Text(
            'Datos de la persona',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          children: [
            TrailingWidget(
              text: '${report.name} ${report.lastname}',
              icon: Icons.person_2_outlined,
            ),
            TrailingWidget(text: report.email, icon: Icons.email_outlined),
            TrailingWidget(
              text: report.address,
              icon: Icons.location_on_outlined,
            ),
            TrailingWidget(
              text:
                  '${report.documentType ?? ''} - ${report.documentNumber ?? ''}',
              icon: Icons.contact_mail_outlined,
            ),
            TrailingWidget(text: report.phone, icon: Icons.phone_outlined),
            const Divider(),
            ImageWithBuilder(imageUrl: report.signatureUrl, width: screenWidth),
          ],
        ),
        const ContractualConditions(),
        PersonalDataProcessingWidget(report: report),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
          child: Text(
            'Recibido por operador: ${report.operatorUsername}',
            style: Theme.of(
              context,
            ).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        ImageWithBuilder(
          imageUrl:
              'https://firebasestorage.googleapis.com/v0/b/diegolopez-drivingschool.appspot.com/o/operator_signatures%2F${report.operatorUsername}@cdapanamericana.com.png?alt=media&token=41fac518-6d4f-4f43-86cd-fceaff5143bc',
          width: screenWidth,
        ),
        const Divider(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
          child: Text(
            report.engineerUsername == null || report.engineerUsername!.isEmpty
                ? 'Revisión Pendiente por Ingeniero'
                : 'Aprobado por Ing. ${report.engineerUsername}',
            style: Theme.of(
              context,
            ).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        if (report.engineerUsername == null ||
            report.engineerUsername!.isNotEmpty)
          ImageWithBuilder(
            imageUrl:
                'https://firebasestorage.googleapis.com/v0/b/diegolopez-drivingschool.appspot.com/o/operator_signatures%2F${report.engineerUsername}@cdapanamericana.com.png?alt=media&token=41fac518-6d4f-4f43-86cd-fceaff5143bc',
            width: screenWidth,
          ),
        const Divider(),
      ],
    );
  }
}
