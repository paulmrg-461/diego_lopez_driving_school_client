import 'package:diego_lopez_driving_school_client/presentation/constants/personal_data_processing.dart';
import 'package:flutter/material.dart';

class ConsentTile extends StatelessWidget {
  final bool inviteEvents;
  final bool shareContact;
  final bool sendNews;
  final bool manageRequests;
  final bool conductSurveys;
  final bool reminderRTMyEC;
  final Function(bool) onInviteEventsChanged;
  final Function(bool) onShareContactChanged;
  final Function(bool) onSendNewsChanged;
  final Function(bool) onManageRequestsChanged;
  final Function(bool) onConductSurveysChanged;
  final Function(bool) onReminderRTMyECChanged;

  const ConsentTile({
    super.key,
    required this.inviteEvents,
    required this.shareContact,
    required this.sendNews,
    required this.manageRequests,
    required this.conductSurveys,
    required this.reminderRTMyEC,
    required this.onInviteEventsChanged,
    required this.onShareContactChanged,
    required this.onSendNewsChanged,
    required this.onManageRequestsChanged,
    required this.onConductSurveysChanged,
    required this.onReminderRTMyECChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      initiallyExpanded: false,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Consentimiento para el uso de datos',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Text(
            'CDA PANAMERICANA SAS,  será la responsable del Tratamiento de los datos personales que se registren en este documento y, en tal virtud, los podrá Recolectar, Almacenar, Usar y Circular para las siguientes finalidades:',
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ],
      ),
      children: [
        SwitchListTile(
          title: Text(
            'Realizar invitaciones a eventos y ofrecer nuevos productos y servicios.',
            style: Theme.of(context).textTheme.labelSmall,
          ),
          value: inviteEvents,
          onChanged: onInviteEventsChanged,
        ),
        SwitchListTile(
          title: Text(
            'Suministrar información de contacto a la fuerza comercial y/o red de distribución, telemercadeo, investigación de mercados y cualquier tercero con el cual CDA PANAMERICANA SAS, tenga un vínculo contractual para el desarrollo de actividades de ese tipo (investigación de mercados y telemercadeo) para la ejecución de las mismas.',
            style: Theme.of(context).textTheme.labelSmall,
          ),
          value: shareContact,
          onChanged: onShareContactChanged,
        ),
        SwitchListTile(
          title: Text(
            'Contactar al Titular a través de medios telefónicos, medios electrónicos, SMS, WhatsApp y redes sociales para el envío de noticias relacionadas con campañas de fidelización o mejora de servicio.',
            style: Theme.of(context).textTheme.labelSmall,
          ),
          value: sendNews,
          onChanged: onSendNewsChanged,
        ),
        SwitchListTile(
          title: Text(
            'Gestionar Trámites (solicitudes, quejas, reclamos).',
            style: Theme.of(context).textTheme.labelSmall,
          ),
          value: manageRequests,
          onChanged: onManageRequestsChanged,
        ),
        SwitchListTile(
          title: Text(
            'Contactar al Titular a través de medios telefónicos, medios electrónicos, SMS, WhatsApp y redes sociales para realizar encuestas, estudios y/o confirmación de datos personales.',
            style: Theme.of(context).textTheme.labelSmall,
          ),
          value: conductSurveys,
          onChanged: onConductSurveysChanged,
        ),
        SwitchListTile(
          title: Text(
            'Contactar al Titular a través de medios telefónicos, medios electrónicos, SMS, WhatsApp y redes sociales para recordar sobre el vencimiento del certificado de RTMyEC y del SOAT.',
            style: Theme.of(context).textTheme.labelSmall,
          ),
          value: reminderRTMyEC,
          onChanged: onReminderRTMyECChanged,
        ),
        const Divider(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children:
                dataProcessingRights.map((right) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2.0),
                    child: RichText(
                      text: TextSpan(
                        style: Theme.of(context).textTheme.labelSmall,
                        children: [
                          TextSpan(
                            text: right.substring(0, 2), // "a. "
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: right.substring(2), // Texto después de "a. "
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
    );
  }
}
