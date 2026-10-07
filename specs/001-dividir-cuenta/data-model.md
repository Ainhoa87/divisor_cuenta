# Data Model: Dividir cuenta

All types below are planned as null-safe Dart values. Files under `domain/` use Dart
standard libraries only and do not import Flutter.

## `Cuenta`

Validated inputs for one calculation.

| Field | Type | Rule |
|---|---|---|
| `montoTotal` | `double` | Finite and greater than or equal to zero |
| `numeroPersonas` | `int` | At least one |
| `porcentajePropina` | `double` | Finite and greater than or equal to zero |

The account carries calculation inputs only; text parsing and validation happen before
the calculator receives it.

## `ValidarEntrada`

Accepts the three raw form values and returns either a valid `Cuenta` or a typed input
error. The validation outcome is mutually exclusive: it never contains both a `Cuenta`
and an error, or neither. A small domain error enum distinguishes invalid amount,
insufficient people, and invalid tip. Presentation maps these error codes to Spanish
messages; the calculator does not validate or format.

Validation rules:

- Amount must be present, numeric, finite, and nonnegative. The specified error text is
  `Monto inválido`.
- People must parse as a whole number of at least one. The specified error text for
  zero people is `Debe haber al menos una persona`.
- Tip must be numeric, finite, and nonnegative. Its message may be a concise Spanish
  validation message, as permitted by the specification.
- A failed calculation clears any previously displayed result.

## `EstrategiaRedondeo`

Pure Dart interface with one method receiving a numeric per-person share and returning
the adjusted numeric share. It is the abstraction consumed by `CalcularDivision`.

## Strategy registry

`DivisorController` receives an open `Map<String, EstrategiaRedondeo>` by constructor.
`main.dart` registers the initial keys `exacto` and `hacia-arriba`; presentation receives
the corresponding display labels and derives its options from the registry. Adding a
strategy adds an implementation and a composition registration without changing the
existing calculation, controller, screen, or a closed mode enum.

## `CalcularDivision`

Receives a valid `Cuenta` and an `EstrategiaRedondeo`. It calculates:

`totalConPropina = montoTotal + montoTotal * porcentajePropina / 100`

`importeBasePorPersona = totalConPropina / numeroPersonas`

It passes the base share to the strategy and returns a `Resultado`. It does not parse,
validate, choose concrete strategies, or format display text.

## `Resultado`

Successful numeric output of a calculation.

| Field | Type | Meaning |
|---|---|---|
| `totalConPropina` | `double` | Full bill including tip |
| `importePorPersona` | `double` | Share after applying the selected strategy |

Presentation formats `importePorPersona` to two decimal places. In upward mode an
integer result is still displayed with `.00`.

## Rounding implementations in `data/`

- `RedondeoExacto`: returns the input share unchanged; presentation shows two decimals.
- `RedondeoHaciaArriba`: returns the next integer if the input share has a fractional
  part; if already an integer, returns it unchanged.

Neither implementation mutates the account or result, and both can substitute through
`EstrategiaRedondeo`.
