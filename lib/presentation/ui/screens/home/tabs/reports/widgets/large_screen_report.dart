import 'package:diego_lopez_driving_school_client/config/global/environment.dart';
import 'package:diego_lopez_driving_school_client/core/helpers/human_formats.dart';
import 'package:diego_lopez_driving_school_client/domain/entities/attendance_report.dart';
import 'package:diego_lopez_driving_school_client/presentation/constants/conditions_rte.dart';
import 'package:diego_lopez_driving_school_client/presentation/constants/personal_data_processing.dart';
import 'package:diego_lopez_driving_school_client/presentation/ui/widgets/custom_asset_image.dart';
import 'package:diego_lopez_driving_school_client/presentation/ui/widgets/image_with_builder.dart';
import 'package:flutter/material.dart';

class LargeScreenReport extends StatelessWidget {
  final AttendanceReport report;
  final bool isSecondVisit;

  const LargeScreenReport({
    super.key,
    required this.report,
    required this.isSecondVisit,
  });

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.all(8.0),
      color: Colors.white,
      child: ListView(
        children: [
          _buildReportHeader(context),
          _buildReportBody(context: context, size: size),
        ],
      ),
    );
  }

  Widget _buildReportHeader(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 4),
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black45, width: 1.2),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'ORDEN DE SERVICIO',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                ),
                Container(
                  decoration: const BoxDecoration(
                    border: Border.symmetric(
                      horizontal: BorderSide(color: Colors.black45, width: 1.2),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'F-036',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(fontWeight: FontWeight.w900),
                        ),
                        Text(
                          'REVISIÓN TÉCNICO MECÁNICA Y DE EMISIONES CONTAMINANTES',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(fontWeight: FontWeight.w900),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Página 1 de 3',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      Text(
                        'Versión ',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      Text(
                        'Fecha de Emisión: ',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(5),
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black45, width: 1.2),
          ),
          child: const Row(
            children: [
              CustomAssetImage(path: 'assets/supertransporte.png', height: 52),
              CustomAssetImage(path: 'assets/logo.png', height: 40),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildReportBody({required BuildContext context, required Size size}) {
    final String visitNumber = isSecondVisit ? '2' : '1';
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black45, width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Fecha: ${HumanFormats.convertDate(report.createdAt)}   ${HumanFormats.convertTime(report.createdAt)}',
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall!.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  'Visita: #$visitNumber',
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall!.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  'Placa: ${report.licensePlate}',
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall!.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  'Kilometraje: ${report.mileage}',
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall!.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          // Detalles del Vehículo
          Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black45, width: 1.2),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Marca, Servicio, Color
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Marca: ${report.brand}',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall!
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Servicio: ${report.serviceType}',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall!
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Color: ${report.color}',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall!
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      // Licencia de tránsito, SOAT, Pasajeros, Enseñanza
                      Container(
                        decoration: const BoxDecoration(
                          border: Border.symmetric(
                            horizontal: BorderSide(
                              color: Colors.black45,
                              width: 1.2,
                            ),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Licencia de tránsito: ${report.hasAttendanceOwnershipCard ?? false ? 'SI' : 'NO'}',
                                style: Theme.of(context).textTheme.labelMedium,
                              ),
                              Text(
                                'SOAT: ${report.hasSoat ?? false ? 'SI' : 'NO'}',
                                style: Theme.of(context).textTheme.labelMedium,
                              ),
                              Text(
                                'Pasajeros: ${report.passengersQuantity ?? 1}',
                                style: Theme.of(context).textTheme.labelMedium,
                              ),
                              Text(
                                'Enseñanza: ${report.isTeachingAttendance ?? false ? 'SI' : 'NO'}',
                                style: Theme.of(context).textTheme.labelMedium,
                              ),
                              const SizedBox(width: 2),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.black45,
                              width: 1.2,
                            ),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Vehículo Limpio: ${report.isAttendanceClean ?? false ? 'SI' : 'NO'}',
                                style: Theme.of(context).textTheme.labelMedium,
                              ),
                              Text(
                                'Copas: ${report.hasCups ?? false ? 'SI' : 'NO'}',
                                style: Theme.of(context).textTheme.labelMedium,
                              ),
                              Text(
                                'Condición que impida ingreso: ${report.hasTroubleEntering ?? false ? 'SI' : 'NO'}',
                                style: Theme.of(context).textTheme.labelMedium,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Vehículo Descargado: ${report.isDischarged ?? false ? 'SI' : 'NO'}',
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                            const SizedBox(width: 52),
                            Text(
                              'Combustible suficiente: ${report.hasFuel ?? false ? 'SI' : 'NO'}',
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                          ],
                        ),
                      ),
                      // Alarma Desactivada, Soporte Central
                      Container(
                        decoration: const BoxDecoration(
                          border: Border.symmetric(
                            horizontal: BorderSide(
                              color: Colors.black45,
                              width: 1.2,
                            ),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Alarma desactivada: ${report.isAlarmDeactivated ?? false ? 'SI' : 'NO'}',
                                style: Theme.of(context).textTheme.labelMedium,
                              ),
                              const SizedBox(width: 61),
                              Text(
                                'Soporte Central: ${report.hasCenterSupport ?? false ? 'SI' : 'NO'}',
                                style: Theme.of(context).textTheme.labelMedium,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 4, left: 4),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Obstáculo para revisar nivel líquido de frenos: ',
                                  style:
                                      Theme.of(context).textTheme.labelMedium,
                                ),
                              ],
                            ),
                            Text(
                              report.obstacleToCheckingBrakeFluid ?? 'NO',
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                            const SizedBox(height: 6),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Imagen del Estado del Vehículo
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black45, width: 1.2),
                ),
                child: Column(
                  children: [
                    ImageWithBuilder(
                      imageUrl: report.attendanceStateImageUrl,
                      height: 90,
                    ),
                    Text(
                      'Presión Llantas (PSI): D: ${report.frontPressure} - T: ${report.rearPressure}',
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          // Observaciones
          Padding(
            padding: const EdgeInsets.only(left: 4, right: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Observaciones:',
                      style: Theme.of(context).textTheme.titleSmall!,
                    ),
                  ],
                ),
                Text(
                  report.observations,
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ],
            ),
          ),
          // Firma de Recepción
          Container(
            decoration: const BoxDecoration(
              border: Border.symmetric(
                horizontal: BorderSide(color: Colors.black45, width: 1.2),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Responsable de la recepción:',
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SignatureImage(
                        height: 46,
                        imageUrl:
                            'https://firebasestorage.googleapis.com/v0/b/diegolopez-drivingschool.appspot.com/o/operator_signatures%2F${Environment.receptionist}@diegolopez.com.png?alt=media&token=41fac518-6d4f-4f43-86cd-fceaff5143bc',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // Vehículo Preparado para Inspección
          Container(
            decoration: const BoxDecoration(
              border: Border.symmetric(
                horizontal: BorderSide(color: Colors.black45, width: 1.2),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Vehículo preparado para ser inspeccionado:',
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 26, right: 17),
                    decoration: BoxDecoration(
                      color: Colors.green[100],
                      border: const Border.symmetric(
                        vertical: BorderSide(color: Colors.black45, width: 1.2),
                      ),
                    ),
                    child: Text(
                      'SI  ✔️',
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    decoration: const BoxDecoration(
                      border: Border.symmetric(
                        vertical: BorderSide(color: Colors.black45, width: 1.2),
                      ),
                    ),
                    child: Text(
                      'NO',
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Condiciones Contractuales
          Container(
            color: Colors.black12,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Condiciones contractuales para la prestación del Servicio de Revisión Técnico Mecánica y de Emisiones Contaminantes',
                    style: Theme.of(context).textTheme.labelSmall!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              border: Border.symmetric(
                horizontal: BorderSide(color: Colors.black45, width: 1.2),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                conditions[0] ?? '',
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ),
          ),
          // Lista de Condiciones Contractuales
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: conditions.keys.map((conditionId) {
              final conditionText = conditions[conditionId];
              if (conditionId != 0 &&
                  conditionText != null &&
                  conditionText.isNotEmpty) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 1.5),
                  child: Text(
                    '$conditionId. $conditionText',
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                );
              }
              return const SizedBox();
            }).toList(),
          ),
          // Tratamiento de Datos Personales
          Container(
            decoration: const BoxDecoration(
              color: Colors.black12,
              border: Border.symmetric(
                horizontal: BorderSide(color: Colors.black45, width: 1.2),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'TRATAMIENTO DE DATOS PERSONALES',
                    style: Theme.of(context).textTheme.labelSmall!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
          ),
          // Finalidades de Tratamiento de Datos
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              'CDA PANAMERICANA SAS, será la responsable del Tratamiento de los datos personales que se registren en este documento y, en tal virtud, los podrá Recolectar, Almacenar, Usar y Circular para las siguientes finalidades:',
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              border: Border.symmetric(
                horizontal: BorderSide(color: Colors.black45, width: 1.2),
              ),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: const BoxDecoration(
                    color: Colors.black12,
                    border: Border(
                      bottom: BorderSide(color: Colors.black45, width: 1.2),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'FINALIDAD',
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'AUTORIZA',
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                ...dataProcessingPurposesList.asMap().entries.map((entry) {
                  int index = entry.key;
                  String purpose = entry.value;
                  bool switchValue = false;

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

                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.black45, width: 1.2),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                            border: Border(
                              right: BorderSide(
                                color: Colors.black45,
                                width: 1.2,
                              ),
                            ),
                          ),
                          width: size.width * 0.86,
                          padding: const EdgeInsets.symmetric(vertical: 1),
                          child: Text(
                            purpose,
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            switchValue ? 'SI' : 'NO',
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
          // Derechos de Tratamiento de Datos
          ...dataProcessingRights.asMap().entries.map((entry) {
            final String value = entry.value;
            final int key = entry.key;
            if (key != 0) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 1),
                child: RichText(
                  text: TextSpan(
                    style: Theme.of(context).textTheme.labelSmall,
                    children: [
                      TextSpan(
                        text: value.substring(0, 2), // "a. "
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: value.substring(2), // Texto después de "a. "
                      ),
                    ],
                  ),
                ),
              );
            }
            return Container(
              decoration: const BoxDecoration(
                color: Colors.black12,
                border: Border(
                  bottom: BorderSide(color: Colors.black45, width: 1.2),
                ),
              ),
              padding: const EdgeInsets.symmetric(vertical: 1),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    value,
                    style: Theme.of(context).textTheme.labelMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            );
          }),
          // Declaración de Consentimiento
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            decoration: const BoxDecoration(
              border: Border.symmetric(
                horizontal: BorderSide(color: Colors.black45, width: 1.2),
              ),
            ),
            child: Text(
              'Teniendo en cuenta todo lo descrito en este documento, como TITULAR de los datos personales otorga consentimiento al CDA PANAMERICANA SAS, para que trate la información personal de acuerdo con la Política de Tratamiento de Datos Personales presentada en documento físico localizado en la sala de espera del CDA PANAMERICANA SAS, localizado en la transversal 9 Nº 6 Norte - 35 Popayán y se da a conocer antes de recolectar los datos en este documento.',
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ),
          // Datos del Titular
          Container(
            color: Colors.black12,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'DATOS DEL TITULAR DE LOS DATOS PERSONALES',
                    style: Theme.of(context).textTheme.labelSmall!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              border: Border.symmetric(
                horizontal: BorderSide(color: Colors.black45, width: 1.2),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Nombres y Apellidos: ${report.name} ${report.lastname}',
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Text(
                    'Celular/Teléfono: ${report.phone}',
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Correo electrónico: ${report.email}',
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall!.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  'Dirección: ${report.address}',
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall!.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          // Aceptación de Condiciones Contractuales
          Container(
            decoration: const BoxDecoration(
              border: Border.symmetric(
                horizontal: BorderSide(color: Colors.black45, width: 1.2),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: size.width * 0.34,
                    child: Text(
                      'Acepto los lineamientos y condiciones contractuales relacionados en el presente documento y manifiesto que la presente autorización me fue solicitada antes de entregar mis datos y la suscribo de forma libre y voluntaria una vez leída en su totalidad al igual que la Política de Tratamiento de Datos Personales.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ),
                  Container(
                    width: size.width * 0.61,
                    padding: const EdgeInsets.only(left: 4),
                    decoration: const BoxDecoration(
                      border: Border(
                        left: BorderSide(color: Colors.black45, width: 1.2),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Por medio de la presenten declaro:',
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                        ...dataClarenseRights.asMap().entries.map((entry) {
                          final String value = entry.value;
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 1),
                            child: RichText(
                              text: TextSpan(
                                style: Theme.of(context).textTheme.labelSmall,
                                children: [
                                  TextSpan(
                                    text: value.substring(0, 2), // "a. "
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextSpan(
                                    text: value.substring(
                                      2,
                                    ), // Texto después de "a. "
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Firma del Cliente y del Director Técnico
          Container(
            decoration: const BoxDecoration(
              border: Border.symmetric(
                horizontal: BorderSide(color: Colors.black45, width: 1.2),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: size.width * 0.45,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Firma del cliente',
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        SignatureImage(imageUrl: report.signatureUrl),
                        Text(
                          'Cédula: ${report.documentNumber}',
                          style: Theme.of(context).textTheme.titleSmall!,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: size.width * 0.45,
                    padding: const EdgeInsets.only(left: 4),
                    decoration: const BoxDecoration(
                      border: Border(
                        left: BorderSide(color: Colors.black45, width: 1.2),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Firma de director técnico',
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        SignatureImage(
                          imageUrl:
                              'https://firebasestorage.googleapis.com/v0/b/diegolopez-drivingschool.appspot.com/o/operator_signatures%2F${report.engineerUsername}@diegolopez.com.png?alt=media&token=41fac518-6d4f-4f43-86cd-fceaff5143bc',
                        ),
                        Text(
                          '',
                          style: Theme.of(context).textTheme.titleSmall!,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Créditos y Derechos Reservados
          Text(
            'Software de CDA PANAMERICANA SAS © 2024 Todos los derechos reservados',
            style: Theme.of(context).textTheme.labelSmall,
          ),
          Text(
            'Desarrollado por: DevPaul',
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ],
      ),
    );
  }
}

class SignatureImage extends StatelessWidget {
  const SignatureImage({
    super.key,
    this.imageUrl =
        'https://www.pngkey.com/png/detail/233-2332677_image-500580-placeholder-transparent.png',
    this.height = 60,
  });

  final String? imageUrl;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      margin: const EdgeInsets.all(4),
      child: Image.network(
        imageUrl!,
        fit: BoxFit.fitWidth,
        loadingBuilder: (context, child, progress) {
          if (progress == null) {
            return child;
          } else {
            return Center(
              child: CircularProgressIndicator(
                value: progress.expectedTotalBytes != null
                    ? progress.cumulativeBytesLoaded /
                        (progress.expectedTotalBytes ?? 1)
                    : null,
              ),
            );
          }
        },
        errorBuilder: (context, error, stackTrace) {
          return const Center(child: Icon(Icons.error));
        },
      ),
    );
  }
}
