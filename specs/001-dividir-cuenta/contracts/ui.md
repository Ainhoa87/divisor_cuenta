# UI Contract: Dividir cuenta

This application exposes no network API or database contract. Its public interaction is
the single-screen form below.

## Inputs

- **Monto total**: numeric, nonnegative amount.
- **Personas**: whole-number count; must be at least one.
- **Propina**: numeric, nonnegative percentage.
- **Redondeo**: one of `Exacto` or `Hacia arriba`.

## Action

The user selects **Calcular** to validate the current fields and calculate. Editing a
field alone does not calculate. A successful action shows the amount per person with two
decimal places. In `Hacia arriba` mode, each share is rounded up to the next whole unit
before display.

## Outcomes

| Condition | Visible outcome |
|---|---|
| Valid amount, people, and tip | Result for each person, formatted to two decimals |
| Zero people | `Debe haber al menos una persona`; no result |
| Empty or invalid amount | `Monto inválido`; no result |
| Other invalid numeric input | Concise Spanish validation message; no result |
| Invalid attempt after a successful calculation | Error message; previous result is cleared |

The screen requires no Internet connection and has no persistence across app closure.
