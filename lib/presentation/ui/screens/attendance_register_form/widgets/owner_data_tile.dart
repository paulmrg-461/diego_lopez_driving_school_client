import 'package:diego_lopez_driving_school_client/core/validators/input_validators.dart';
import 'package:diego_lopez_driving_school_client/presentation/ui/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:signature/signature.dart';

class OwnerDataTile extends StatelessWidget {
  final double inputsWidth;
  final TextEditingController nameController;
  final TextEditingController lastnameController;
  final TextEditingController docNumberController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController addressController;
  final SignatureController signatureController;
  final Function(String?) onDocTypeChanged;
  final String? docType;
  final bool isLocked;
  final VoidCallback onToggleLock;

  const OwnerDataTile({
    super.key,
    required this.inputsWidth,
    required this.nameController,
    required this.lastnameController,
    required this.docNumberController,
    required this.emailController,
    required this.phoneController,
    required this.addressController,
    required this.signatureController,
    required this.onDocTypeChanged,
    required this.docType,
    required this.isLocked,
    required this.onToggleLock,
  });

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return ExpansionTile(
      initiallyExpanded: true,
      title: Text(
        'Datos del titular',
        style: Theme.of(context).textTheme.titleMedium,
      ),
      children: [
        Wrap(
          children: [
            CustomInput(
              width: inputsWidth,
              hintText: "Nombres",
              controller: nameController,
              validator:
                  (value) => InputValidator.emptyValidator(
                    minCharacters: 3,
                    value: value,
                  ),
              textCapitalization: TextCapitalization.words,
              textInputType: TextInputType.name,
              icon: Icons.person_outline,
              marginBottom: 4,
            ),
            CustomInput(
              width: inputsWidth,
              hintText: "Apellidos",
              controller: lastnameController,
              validator:
                  (value) => InputValidator.emptyValidator(
                    minCharacters: 3,
                    value: value,
                  ),
              textCapitalization: TextCapitalization.words,
              textInputType: TextInputType.name,
              icon: Icons.person_outline,
              marginBottom: 4,
            ),
            CustomDropdownSearcher(
              hintText: 'Tipo de documento',
              optionList: const [
                'CC',
                'Cédula extranjería',
                'Tarjeta identidad',
                'Nit',
              ],
              action: onDocTypeChanged,
              width: inputsWidth,
              icon: Icons.badge_outlined,
              initialValue: docType,
            ),
            CustomInput(
              width: inputsWidth,
              hintText: "Identificación",
              controller: docNumberController,
              validator: (value) => InputValidator.numberValidator(value),
              textInputType: TextInputType.number,
              isNumeric: true,
              icon: Icons.badge_outlined,
              marginBottom: 4,
            ),
            CustomInput(
              width: inputsWidth,
              hintText: "Celular",
              controller: phoneController,
              validator: (value) => InputValidator.numberValidator(value),
              textInputType: TextInputType.phone,
              isNumeric: true,
              icon: Icons.phone_outlined,
              marginBottom: 4,
            ),
            CustomInput(
              width: inputsWidth,
              hintText: "Correo electrónico",
              controller: emailController,
              validator: (value) => InputValidator.emailValidator(value),
              textCapitalization: TextCapitalization.none,
              textInputType: TextInputType.emailAddress,
              icon: Icons.email_outlined,
              marginBottom: 4,
            ),
            CustomInput(
              width: inputsWidth,
              hintText: "Dirección",
              controller: addressController,
              validator: (value) => InputValidator.emptyValidator(value: value),
              textCapitalization: TextCapitalization.words,
              textInputType: TextInputType.streetAddress,
              icon: Icons.location_on_outlined,
              marginBottom: 4,
            ),
          ],
        ),
        const SizedBox(height: 8),
        Stack(
          children: [
            AbsorbPointer(
              absorbing: isLocked,
              child: Signature(
                controller: signatureController,
                width: screenWidth,
                height: 210,
                backgroundColor: Colors.grey[200]!,
              ),
            ),
            const Positioned(left: 16, top: 8, child: Text('Firma cliente:')),
            Positioned(
              right: 6,
              top: 0,
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => signatureController.clear(),
                    icon: const Icon(Icons.clear_rounded),
                    tooltip: 'Limpiar estado',
                  ),
                  IconButton(
                    onPressed: onToggleLock, // Alternar el bloqueo
                    icon: Icon(
                      isLocked ? Icons.lock_rounded : Icons.lock_open_rounded,
                      color: isLocked ? Colors.red : Colors.green,
                    ),
                    tooltip:
                        isLocked
                            ? 'Desbloquear Interacción'
                            : 'Bloquear Interacción',
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
