# Quickstart: Dividir cuenta

## Prerequisites

- Flutter installed on its stable channel, with the Dart SDK bundled with Flutter.
- The project checked out locally.
- No Internet connection is required while using the calculator. It uses only the
  Flutter SDK and its bundled `flutter_test` package.

## Setup and validation commands

Run these commands from the project root:

```powershell
flutter pub get
flutter analyze
flutter test
flutter run
```

`flutter_test` is included with the Flutter SDK. `flutter analyze` should complete with
no issues. `flutter test` covers the six acceptance scenarios, invalid inputs, and an
offline calculation with HTTP client creation blocked.

## Acceptance walkthrough

On the single screen, enter the values, select the rounding mode, and press **Calcular**.

| Scenario | Inputs | Expected result |
|---|---|---|
| 1 | 100.00; 4 people; 10%; Exacto | 27.50 per person |
| 2 | 90.00; 3 people; 0%; Exacto | 30.00 per person |
| 3 | 50.00; 0 people | `Debe haber al menos una persona`; no result |
| 4 | Amount `abc` | `Monto inválido`; no result |
| 5 | 10.00; 3 people; 0%; Exacto | 3.33 per person |
| 6 | 10.00; 3 people; 0%; Hacia arriba | 4.00 per person |

For the offline criterion, enable airplane mode, enter valid values, and confirm that a
calculation still succeeds. No network call or database is part of the calculation.

The automated offline test blocks HTTP client creation. For a manual device check,
enable airplane mode and repeat a valid calculation.
