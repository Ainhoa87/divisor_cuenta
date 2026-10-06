# Instrucciones del proyecto

- **Descripción:** app Flutter de una sola pantalla para dividir una cuenta.
- **Estructura:** organiza el código en `lib/presentation`, `lib/domain` y `lib/data`. Las dependencias siguen `presentation -> domain <- data`; `domain` no importa ningún módulo de `package:flutter`.
- **Estándares:** usa null safety, nombres en español y evita paquetes externos.
- **Límites:** no modifiques `test/` sin que te lo pidan. No agregues dependencias a `pubspec.yaml` sin avisar. No modifiques `android/` ni `ios/`.
- **Comandos del proyecto:** `flutter pub get`, `flutter run`, `flutter analyze` y `flutter test`.
