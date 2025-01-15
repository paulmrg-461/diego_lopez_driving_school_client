import 'package:diego_lopez_driving_school_client/core/validators/input_validators.dart';
import 'package:diego_lopez_driving_school_client/presentation/constants/motorcycle_brands.dart';
import 'package:diego_lopez_driving_school_client/presentation/constants/motorcycle_colors.dart';
import 'package:diego_lopez_driving_school_client/presentation/constants/service_types.dart';
import 'package:diego_lopez_driving_school_client/presentation/ui/widgets/widgets.dart';
import 'package:flutter/material.dart';

class AttendanceDataTile extends StatelessWidget {
  final TextEditingController licensePlateController;
  final TextEditingController mileageController;
  final TextEditingController yearController;
  final TextEditingController frontPressureController;
  final TextEditingController rearPressureController;
  final TextEditingController observationsController;
  final TextEditingController passengersController;
  final TextEditingController obstacleToCheckingBrakeFluid;
  final double inputsWidth;
  final String? brand;
  final String? color;
  final String? serviceType;
  final Function(String?) onBrandChanged;
  final Function(String?) onColorChanged;
  final Function(String?) onServiceTypeChanged;
  final bool hasAttendanceOwnershipCard;
  final bool hasSoat;
  final bool isTeachingAttendance;
  final bool isDischarged;
  final bool isAlarmDeactivated;
  final bool hasCenterSupport;
  final bool isAttendanceClean;
  final bool hasCups;
  final bool hasTroubleEntering;
  final bool hasFuel;
  final bool hasObstacleToCheckingBrakeFluid;
  final Function(bool) onAttendanceOwnershipCardChanged;
  final Function(bool) onSoatChanged;
  final Function(bool) onTeachingAttendanceChanged;
  final Function(bool) onDischargedChanged;
  final Function(bool) onAlarmDeactivatedChanged;
  final Function(bool) onCenterSupportChanged;
  final Function(bool) onAttendanceCleanChanged;
  final Function(bool) onHasCupsChanged;
  final Function(bool) onHasTroubleEnteringChanged;
  final Function(bool) onHasFuelChanged;
  final Function(bool) onHasObstacleToCheckingBrakeFluidChanged;

  const AttendanceDataTile({
    super.key,
    required this.inputsWidth,
    required this.licensePlateController,
    required this.mileageController,
    required this.yearController,
    required this.frontPressureController,
    required this.rearPressureController,
    required this.observationsController,
    required this.brand,
    required this.color,
    required this.serviceType,
    required this.onBrandChanged,
    required this.onColorChanged,
    required this.onServiceTypeChanged,
    required this.passengersController,
    required this.hasAttendanceOwnershipCard,
    required this.hasSoat,
    required this.isTeachingAttendance,
    required this.isDischarged,
    required this.isAlarmDeactivated,
    required this.hasCenterSupport,
    required this.onAttendanceOwnershipCardChanged,
    required this.onSoatChanged,
    required this.onTeachingAttendanceChanged,
    required this.onDischargedChanged,
    required this.onAlarmDeactivatedChanged,
    required this.onCenterSupportChanged,
    required this.obstacleToCheckingBrakeFluid,
    required this.isAttendanceClean,
    required this.hasCups,
    required this.hasTroubleEntering,
    required this.hasFuel,
    required this.onAttendanceCleanChanged,
    required this.onHasCupsChanged,
    required this.onHasTroubleEnteringChanged,
    required this.onHasFuelChanged,
    required this.onHasObstacleToCheckingBrakeFluidChanged,
    required this.hasObstacleToCheckingBrakeFluid,
  });

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return ExpansionTile(
      initiallyExpanded: true,
      title: Text(
        'Datos del vehículo',
        style: Theme.of(context).textTheme.titleMedium,
      ),
      children: [
        Wrap(
          children: [
            CustomInput(
              width: inputsWidth,
              hintText: "Placa",
              controller: licensePlateController,
              validator: (value) => InputValidator.licensePlateValidator(value),
              textCapitalization: TextCapitalization.characters,
              maxLenght: 6,
              icon: Icons.car_crash_outlined,
              marginBottom: 4,
            ),
            CustomInput(
              width: inputsWidth,
              hintText: "Kilometraje",
              controller: mileageController,
              validator: (value) => InputValidator.numberValidator(value),
              textInputType: TextInputType.number,
              isNumeric: true,
              icon: Icons.speed_outlined,
              marginBottom: 4,
            ),
            CustomDropdownSearcher(
              hintText: 'Marca',
              optionList: motorcycleBrands,
              action: onBrandChanged,
              width: inputsWidth,
              icon: Icons.delivery_dining_outlined,
              initialValue: brand,
            ),
            CustomInput(
              width: inputsWidth,
              hintText: "Año",
              controller: yearController,
              validator: (value) =>
                  InputValidator.numberLengthValidator(value, 4),
              textInputType: TextInputType.number,
              maxLenght: 4,
              isNumeric: true,
              icon: Icons.speed_outlined,
              marginBottom: 4,
            ),
            CustomDropdownSearcher(
              hintText: 'Servicio',
              optionList: serviceTypes,
              action: onServiceTypeChanged,
              width: inputsWidth,
              icon: Icons.badge_outlined,
              initialValue: serviceType,
            ),
            CustomDropdownSearcher(
              hintText: 'Color',
              optionList: motorcycleColors,
              action: onColorChanged,
              width: inputsWidth,
              icon: Icons.color_lens_outlined,
              initialValue: color,
            ),
            CustomInput(
              width: inputsWidth,
              hintText: "Presión llanta delantera",
              controller: frontPressureController,
              validator: (value) =>
                  InputValidator.numberLengthValidator(value, 2),
              textInputType: TextInputType.number,
              maxLenght: 2,
              isNumeric: true,
              icon: Icons.tire_repair_outlined,
              marginBottom: 4,
            ),
            CustomInput(
              width: inputsWidth,
              hintText: "Presión llanta trasera",
              controller: rearPressureController,
              validator: (value) =>
                  InputValidator.numberLengthValidator(value, 2),
              textInputType: TextInputType.number,
              maxLenght: 2,
              isNumeric: true,
              icon: Icons.tire_repair_outlined,
              marginBottom: 4,
            ),
          ],
        ),
        const Divider(),
        Wrap(
          children: [
            CustomSwitchTileDense(
              text: 'Licencia de tránsito',
              value: hasAttendanceOwnershipCard,
              onChanged: onAttendanceOwnershipCardChanged,
              width: inputsWidth,
            ),
            CustomSwitchTileDense(
              text: 'SOAT',
              value: hasSoat,
              onChanged: onSoatChanged,
              width: inputsWidth,
            ),
            CustomInput(
              width: inputsWidth,
              hintText: "Pasajeros",
              controller: passengersController,
              validator: (value) =>
                  InputValidator.numberLengthValidator(value, 1),
              textInputType: TextInputType.number,
              maxLenght: 1,
              isNumeric: true,
              icon: Icons.numbers_outlined,
              // marginBottom: 4,
            ),
            CustomSwitchTileDense(
              text: 'Enseñanza',
              value: isTeachingAttendance,
              onChanged: onTeachingAttendanceChanged,
              width: inputsWidth,
            ),
            CustomSwitchTileDense(
              text: 'Vehículo limpio',
              value: isAttendanceClean,
              onChanged: onAttendanceCleanChanged,
              width: inputsWidth,
            ),
            CustomSwitchTileDense(
              text: 'Copas',
              value: hasCups,
              onChanged: onHasCupsChanged,
              width: inputsWidth,
            ),
            CustomSwitchTileDense(
              text: 'Condición que impida ingreso',
              value: hasTroubleEntering,
              onChanged: onHasTroubleEnteringChanged,
              width: inputsWidth,
            ),
            CustomSwitchTileDense(
              text: 'Vehículo descargado',
              value: isDischarged,
              onChanged: onDischargedChanged,
              width: inputsWidth,
            ),
            CustomSwitchTileDense(
              text: 'Combustible suficiente',
              value: hasFuel,
              onChanged: onHasFuelChanged,
              width: inputsWidth,
            ),
            CustomSwitchTileDense(
              text: 'Alarma desactivada',
              value: isAlarmDeactivated,
              onChanged: onAlarmDeactivatedChanged,
              width: inputsWidth,
            ),
            CustomSwitchTileDense(
              text: 'Soporte central',
              value: hasCenterSupport,
              onChanged: onCenterSupportChanged,
              width: inputsWidth,
            ),
            CustomSwitchTileDense(
              text: 'Obstáculo para revisar líq.de frenos',
              value: hasObstacleToCheckingBrakeFluid,
              onChanged: onHasObstacleToCheckingBrakeFluidChanged,
              width: inputsWidth,
            ),
          ],
        ),
        if (hasObstacleToCheckingBrakeFluid)
          CustomInput(
            width: screenWidth * 0.93,
            hintText: "Obstáculo para revisar nivel líquido de frenos",
            controller: obstacleToCheckingBrakeFluid,
            icon: Icons.warning_amber_rounded,
            textCapitalization: TextCapitalization.sentences,
            marginBottom: 4,
            minLines: 1,
            maxLines: 4,
          ),
        CustomInput(
          width: screenWidth * 0.93,
          hintText: "Observaciones",
          controller: observationsController,
          icon: Icons.density_small_outlined,
          textCapitalization: TextCapitalization.sentences,
          marginBottom: 8,
          minLines: 3,
          maxLines: 5,
        ),
      ],
    );
  }
}

class CustomSwitchTileDense extends StatelessWidget {
  const CustomSwitchTileDense({
    super.key,
    required this.text,
    required this.value,
    required this.onChanged,
    required this.width,
  });

  final String text;
  final bool value;
  final Function(bool p1) onChanged;
  final double width;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey),
      ),
      width: width,
      height: 46,
      child: SwitchListTile(
        dense: true,
        title: Text(text, style: Theme.of(context).textTheme.labelSmall),
        value: value,
        onChanged: onChanged,
      ),
    );
  }
}
