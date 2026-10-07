# Research: Dividir cuenta

## Decision: Use the stable Flutter SDK and no third-party packages

**Rationale**: This is an explicit project constraint. Flutter and Dart provide the
widgets, local state, numeric calculation, formatting, analysis, and test facilities
needed for this one-screen app. The current `pubspec.yaml` still lists
`cupertino_icons` and `flutter_lints`; neither is required by the planned design.
`flutter_test` is supplied by the Flutter SDK.

**Alternatives considered**: Add a state-management or money-formatting package. Rejected
because the screen has short-lived local state and the requirement excludes third-party
packages.

**Sources**: [Dart package environment constraints](https://dart.dev/tools/pub/pubspec),
[Flutter CLI](https://docs.flutter.dev/reference/flutter-cli).

## Decision: Keep screen-local state in `setState`

**Rationale**: The user requested one screen and `setState`. Flutter documents a
`StatefulWidget` and its `State` as the mechanism for state that changes during a
widget's lifetime, with `setState` notifying Flutter to rebuild. Input text, selected
rounding mode, and the latest result are local to this screen.

**Alternatives considered**: A global state-management package or a shared app store.
Rejected because no state is shared across screens and a dependency would add complexity.

**Sources**: [Stateful widget tutorial](https://docs.flutter.dev/learn/pathway/tutorial/stateful-widget),
[Flutter UI interactivity](https://docs.flutter.dev/ui/interactivity).

## Decision: Keep the specified three-layer dependency direction

**Rationale**: Flutter guidance recommends separation between UI and business logic and
tailoring the number of layers to app complexity. This project explicitly requires
`presentation -> domain <- data`, with a Flutter-free Dart domain. The domain owns
calculation and validation; presentation depends on domain contracts; data strategies
implement the domain rounding interface.

**Alternatives considered**: Put all calculation in the widget, or add a repository/data
source for persistence. Rejected because the first conflicts with the constitution and
the second is unnecessary for offline in-memory calculation.

**Sources**: [Flutter architecture concepts](https://docs.flutter.dev/app-architecture/concepts),
[Flutter architecture guide](https://docs.flutter.dev/app-architecture/guide).

## Decision: Verify with Flutter analysis and SDK test tools

**Rationale**: The project's commands include `flutter analyze` and `flutter test`.
Flutter distinguishes unit tests for logic from widget tests for interface interaction;
use both for critical calculation and acceptance behavior. This planning phase does not
run or modify tests.

**Alternatives considered**: Manual-only verification. Rejected because the constitution
requires critical functionality and acceptance scenarios to have executable tests.

**Sources**: [Flutter testing overview](https://docs.flutter.dev/testing/overview),
[Flutter CLI](https://docs.flutter.dev/reference/flutter-cli).

## Local design decisions

- Use the installed stable Flutter channel rather than selecting a new version in this
  plan. Keep the existing Dart lower-bound constraint `^3.13.1` unless implementation
  finds it incompatible with the installed stable SDK.
- The data folder contains only the two requested, stateless rounding strategies; it
  does not access a database or network.
- Rounding-up applies after tip has been added and the total divided by people, matching
  the specified `10.00 / 3 -> 4.00` acceptance result.
- Keep the current USD display convention and format only in presentation. Calculation
  values remain numeric in domain.
