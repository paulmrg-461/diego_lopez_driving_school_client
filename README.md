# Proyecto Flutter: App de Asistencias para la Escuela de Conducción Diego Lopez

Este repositorio contiene la aplicación móvil y versión web desarrollada en **Flutter** para optimizar el registro y gestión de asistencias de los estudiantes de la Escuela de Conducción Diego Lopez. La aplicación permite **crear, visualizar y filtrar** registros de clases teóricas y prácticas, almacenar firmas digitales, y sincronizar los datos con **Firebase** para su posterior consulta y administración desde una **plataforma web**.

---

## Características Principales

1. **Registro de Asistencias**  
   - Formulario para capturar Cédula, Nombre, Teléfono, Tipo de Clase, Fecha/Hora, Cantidad de Horas y Firma.
   - Precarga automática de datos de Nombre y Teléfono si el estudiante ya existe en la base de datos.

2. **Integración con Firebase**  
   - Almacenamiento seguro de registros y firmas.  
   - Gestión de la autenticación de usuarios (opcional).

3. **Compatibilidad con Android y Versión Web**  
   - Aplicación desarrollada en Flutter, permitiendo el despliegue en dispositivos Android.  
   - Implementación de una versión web para la visualización y administración de asistencias en tiempo real.

4. **Firma Digital con S Pen**  
   - Posibilidad de capturar la firma de los estudiantes directamente en un dispositivo con S Pen o soporte táctil.

5. **Búsqueda y Filtrado**  
   - Módulo de reportes con funciones de búsqueda y filtrado para optimizar la gestión de registros.

6. **Escalable y Modificable**  
   - Arquitectura pensada para futuras ampliaciones, como la exportación de reportes a PDF (módulo adicional).

---

## Requisitos Previos

- **Flutter 3.x o superior**  
- **Dart SDK** incluido con la instalación de Flutter  
- **Android Studio** o **VS Code** (con extensiones de Flutter y Dart)  
- **Cuenta de Firebase** con un proyecto activo  
- **SDK Platform Tools** (Android)  
- **Conexión estable a Internet** para la sincronización de datos

---

## Configuración del Entorno

1. **Clonar el Repositorio**

   ```bash
   git clone https://github.com/usuario/flutter-asistencias-diego-lopez.git
   cd flutter-asistencias-diego-lopez
   ```

2. **Instalar Dependencias**

   ```bash
   flutter pub get
   ```

3. **Configurar Firebase**
- Crea un proyecto en Firebase Console.
- Añade una aplicación Android y/o Web según corresponda.
- Descarga el archivo google-services.json (Android) y/o firebaseConfig (Web) y colócalo en la carpeta adecuada:
  - Android: /android/app/
  - Web: /web/
- Actualiza los archivos de configuración de tu proyecto para reflejar la información de tu app en Firebase.

4. **Ejecutar la Aplicación**
- En Android, conecta tu dispositivo o usa un emulador y corre el siguiente comando:
   ```bash
   flutter run
   ```
- Para web, usa el siguiente comando para iniciar el servidor de desarrollo:
   ```bash
   flutter run -d chrome
   ```

---
## Uso de la Aplicación
- Pantalla de Inicio de Sesión (opcional)
Autenticación para garantizar el acceso solo a usuarios autorizados (instructores/administradores).

- Registro de Asistencia
1. Ingresa la Cédula del estudiante.
2. Si ya existe el estudiante en la base de datos, se autocompletarán los campos de Nombre y Teléfono.
3. Selecciona el Tipo de Clase (adaptación, ética, técnicas, práctica, marco legal, taller).
4. Registra la Fecha/Hora y la Cantidad de Horas.
5. Recopila la Firma del estudiante.
6. Guarda el registro en Firebase.

- Visualización y Reportes (Web)
  - Accede a la versión web para consultar todos los registros.
  - Filtra por rango de fechas, tipo de clase, estudiante, etc.
  - Visualiza los detalles de cada asistencia y exporta (módulo adicional) la información en PDF.

## Project Structure

```vbnet
flutter-asistencias-diego-lopez/
├── android/
├── ios/
├── web/
├── lib/
│   ├── models/
│   ├── services/
│   ├── pages/
│   └── main.dart
├── test/
├── pubspec.yaml
└── README.md
```
- assets/: Contains images, icons, and screenshots used in the application.
- lib/: Main source code of the application.
- core/validators/: Contains input validation logic.
- domain/entities/: Defines data models.
- presentation/: UI layer with providers, shared components, and views.
- providers/: State management providers.
- shared/: Reusable widgets and components.
- views/: Different views for large, medium, and small screens.
- web/: Web-specific configurations and assets.
- test/: Contains unit and widget tests.
- pubspec.yaml: Project dependencies and configurations.

## Technologies Used
- Flutter: UI toolkit for building natively compiled applications.
- Dart: Programming language optimized for UI.
- Google Fonts: For custom typography.
- url_launcher: To handle URL launching for the contact form.
- Flutter Localization: For multilingual support.

## Contributing
Contributions are welcome! Follow these steps to get started:

1. **Fork the Repository**

2. **Create a Feature Branch

   ```bash
     git checkout -b feature/YourFeatureName
   ```
3. **Commit Your Changes**

   ```bash
     git commit -m "Add some feature"
   ```
4. **Push to the Branch**

   ```bash
     git push origin feature/YourFeatureName
   ```
   This command will launch the portfolio in your default web browser.
5. **OPen a Pull Request**

## License
This project is licensed under the MIT License.

## Contact
Developed by:
- Paul Realpe
- Jimmy Realpe

Email: co.devpaul@gmail.com

Phone: 3148580454

<a  href="https://devpaul.pro">https://devpaul.pro/</a>

Feel free to reach out for any inquiries or collaborations!