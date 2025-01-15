import 'package:flutter/material.dart';
import 'package:diego_lopez_driving_school_client/presentation/constants/conditions_rte.dart';

class ContractualConditions extends StatelessWidget {
  const ContractualConditions({super.key});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      initiallyExpanded: false,
      title: Text(
        'Condiciones Contractuales para La Prestación Del Servicio De Revisión Técnico Mecánica Y De Emisiones Contaminantes',
        style: Theme.of(context).textTheme.titleMedium,
      ),
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.65,
          child: ListView.builder(
            // shrinkWrap:
            //     true, // Hacemos que la lista se ajuste al tamaño del ExpansionTile
            itemCount: conditions.length,
            itemBuilder: (context, index) {
              final conditionId = conditions.keys.elementAt(
                index,
              ); // Obtener el ID de la condición
              final conditionText =
                  conditions[conditionId]; // Obtener el texto de la condición

              return ListTile(
                title:
                    conditionId == 0
                        ? Text(
                          conditionText ?? '',
                          style: Theme.of(context).textTheme.labelSmall!
                              .copyWith(fontWeight: FontWeight.bold),
                        )
                        : Text(
                          '$conditionId. $conditionText', // Formato de cada ítem con su número y texto
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
              );
            },
          ),
        ),
      ],
    );
  }
}
