import 'package:diego_lopez_driving_school_client/domain/entities/attendance_report.dart';
import 'package:diego_lopez_driving_school_client/presentation/constants/personal_data_processing.dart';
import 'package:flutter/material.dart';

class PersonalDataProcessingWidget extends StatelessWidget {
  final AttendanceReport report;
  const PersonalDataProcessingWidget({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Divider(),
        ExpansionTile(
          initiallyExpanded: false,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'TRATAMIENTO DE DATOS PERSONALES',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 4),
              Text(
                'CDA PANAMERICANA SAS será la responsable del Tratamiento de los datos personales que se registren en este documento y, en tal virtud, los podrá Recolectar, Almacenar, Usar y Circular para las siguientes finalidades:',
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ],
          ),
          children: [
            // Generar SwitchListTiles para cada finalidad
            ...dataProcessingPurposesList.asMap().entries.map((entry) {
              int index = entry.key;
              String purpose = entry.value;
              bool switchValue = false;

              // Mapear cada propósito a su correspondiente valor en el modelo Report
              switch (index) {
                case 0:
                  switchValue = report.inviteEvents;
                  break;
                case 1:
                  switchValue = report.shareContact;
                  break;
                case 2:
                  switchValue = report.sendNews;
                  break;
                case 3:
                  switchValue = report.manageRequests;
                  break;
                case 4:
                  switchValue = report.conductSurveys;
                  break;
                case 5:
                  switchValue = report.reminderRTMyEC;
                  break;
                default:
                  switchValue = false;
              }

              return SwitchListTile(
                title: Text(
                  purpose,
                  style: Theme.of(context).textTheme.labelSmall,
                ),
                value: switchValue,
                onChanged: (value) {}, // Deshabilitar el switch
              );
            }),
            const Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: dataProcessingRights.map((right) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2.0),
                    child: RichText(
                      text: TextSpan(
                        style: Theme.of(context).textTheme.labelSmall,
                        children: [
                          TextSpan(
                            text: right.substring(0, 2), // "a. "
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: right.substring(
                              2,
                            ), // Texto después de "a. "
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ],
    );
  }
}
