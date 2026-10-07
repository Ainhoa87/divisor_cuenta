# Implementation Plan: Dividir cuenta

**Branch**: `sdd` | **Date**: 2026-10-06 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `specs/001-dividir-cuenta/spec.md` plus the
user's architecture constraints for Flutter, Dart, local state, and dependency injection.

## Summary

Implement the one-screen bill splitter with the stable Flutter SDK and no third-party
packages. Keep screen state in `setState`. Put account validation, calculation, and the
rounding contract in pure Dart `domain`; implement exact and ceiling strategies in
`data`; coordinate them through constructor-injected presentation dependencies. `main.dart`
composes all concrete objects. The calculation applies the selected strategy to each
person's share after adding the tip.

## Technical Context

**Language/Version**: Dart from the installed stable Flutter SDK; existing project SDK
lower bound is `^3.13.1`.

**Primary Dependencies**: Flutter SDK only. `flutter_test` is an SDK-provided test
package. No third-party runtime or development packages are planned.

**Storage**: None. Inputs and results live in the screen while the app is open; no
network or database access.

**Testing**: `flutter analyze` and `flutter test`; domain unit coverage for validation,
calculation, and each rounding strategy, plus widget coverage for the acceptance flows.
The existing test directory is outside the scope of this planning change.

**Target Platform**: Flutter-supported app targets already enabled in the repository;
the screen must remain usable without an Internet connection.

**Project Type**: Single-screen Flutter application.

**Performance Goals**: A calculation is local and completes in the same user action;
no network latency is involved.

**Constraints**: One screen; local state with `setState`; Spanish identifiers; null safety;
no third-party packages; pure Dart domain; only `main.dart` creates concrete
implementations; follow `presentation -> domain <- data`.

**Scale/Scope**: One account calculation at a time, one screen, two initial rounding
strategies, and the six acceptance scenarios in the specification.

## Constitution Check

### Before design

- **SOLID**: Pass. Calculation, validation, and formatting remain separate. Rounding
  is represented by a one-method abstraction; the available strategies are registered
  at the composition root, so a new strategy does not require editing existing classes.
- **Architecture**: Pass. The requested `presentation`, `domain`, and `data` layers
  follow `presentation -> domain <- data`; domain stays free of Flutter imports.
- **Composition**: Pass. `main.dart` is the sole composition root for concrete
  strategies and presentation objects.
- **Security/offline**: Pass. No credentials, network, or database are needed.
- **Quality and testing**: Pass as a plan. Critical domain behavior and the six
  acceptance scenarios are assigned executable test coverage; none is claimed as
  implemented or run by this planning step.
- **Course rule**: Pass. The planned types have narrow responsibilities and are
  documented in the data model and contracts for student review.
- **Project constraints**: Pass. Flutter stable, null safety, Spanish names, no
  third-party packages, and no change to `test/`, `android/`, or `ios/` in this phase.

### Post-design gate

**PASS**. The design keeps dependencies pointed inward, injects the abstract rounding
contract, and leaves formatting in presentation. No constitution violation or additional
architecture layer is introduced.

## Project Structure

### Documentation (this feature)

```text
specs/001-dividir-cuenta/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
└── contracts/
    └── ui.md
```

### Source Code (repository root)

```text
lib/
├── main.dart                         # Composition root
├── domain/
│   ├── cuenta.dart
│   ├── resultado.dart
│   ├── calcular_division.dart
│   ├── validar_entrada.dart
│   └── estrategia_redondeo.dart
├── data/
│   ├── redondeo_exacto.dart
│   └── redondeo_hacia_arriba.dart
└── presentation/
    ├── divisor_controller.dart
    ├── formateador_moneda.dart
    └── pantalla_divisor.dart

test/                                 # Existing tests; changes require user request
```

**Structure Decision**: Use the exact three feature layers requested. Domain owns
validated account values and the calculation contract; data provides the two
`EstrategiaRedondeo` implementations; presentation owns inputs, errors, formatting, and
the single screen. The widget calls the controller and invokes `setState` to display
the returned result or validation message. The composition root creates all concrete
implementations and passes abstractions into presentation.

## Complexity Tracking

No constitution violations. No extra application layer or external service is needed.

## Implementation Notes

- `CalcularDivision` receives an `EstrategiaRedondeo` abstraction for a calculation;
  it computes `(monto + monto * propina / 100) / personas` and delegates rounding.
- `DivisorController` receives `ValidarEntrada`, `CalcularDivision`, and an open map of
  strategy identifiers to `EstrategiaRedondeo` by constructor. It selects by identifier
  and never imports concrete `data` types or a closed mode enum.
- `main.dart` creates `RedondeoExacto` and `RedondeoHaciaArriba`, registers them under
  the keys `exacto` and `hacia-arriba`, provides their Spanish labels, and injects the
  registry. The screen renders registered options, so adding a strategy changes only
  the composition registration and adds the new implementation.
- `PantallaDivisor` owns text controllers and the selected strategy identifier. It asks
  the controller to calculate only when the user taps **Calcular**, then uses `setState`
  for the outcome.
- `FormateadorMoneda` formats the result to two decimal places and retains the current
  screen's USD presentation. It does not change the domain value.
- The repository currently declares `cupertino_icons` and `flutter_lints`. Neither is
  needed by the requested design; implementation must remove those third-party
  dependencies and the related lint include. `flutter_test` remains because it is
  provided by the Flutter SDK.
- The two validation messages specified by the feature remain exact. Other invalid
  numeric fields receive a concise Spanish validation message, as allowed by the spec.
