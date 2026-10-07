# Quickstart: Dividir cuenta

## Prerequisites

- Flutter installed on its stable channel, with the Dart SDK bundled with Flutter.
- The project checked out locally.
- No Internet connection is required while using the calculator. Dependency setup may
  contact package servers until the planned dependency cleanup is complete.

## Setup and validation commands

After implementation removes the unused third-party `cupertino_icons` and
`flutter_lints` dependencies:

```powershell
flutter pub get
flutter analyze
flutter test
flutter run
```

`flutter_test` is included with the Flutter SDK. `flutter analyze` should complete with
no issues. `flutter test` should include executable coverage for the six acceptance
scenarios and the pure Dart calculation/validation behavior.

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

This plan phase creates documentation only; it does not change application code,
dependencies, or tests.
