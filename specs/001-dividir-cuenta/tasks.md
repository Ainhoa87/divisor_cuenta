# Tasks: Dividir cuenta

**Input**: Documentos de diseÃ±o en `specs/001-dividir-cuenta/`

**Prerequisites**: `plan.md`, `spec.md`, `research.md`, `data-model.md`, `contracts/ui.md`

**Tests**: La constitución exige pruebas ejecutables para la lógica crítica y los
criterios de aceptación. La solicitud `/speckit-implement` autoriza completar las
tareas de prueba de este plan.

**Organization**: Las tareas se agrupan por historia de usuario para permitir la
implementaciÃ³n y verificaciÃ³n incremental.

## Format: `[ID] [P?] [Story] Description`

- `[P]`: tarea paralelizable en archivos distintos y sin dependencias pendientes.
- `[Story]`: historia de usuario asociada.
- Toda tarea concreta identifica sus rutas de archivo.

## Phase 1: Setup

**Purpose**: Dejar el proyecto sin dependencias externas, como pide el plan.

- [x] T001 Retirar `cupertino_icons` y `flutter_lints` de `pubspec.yaml`, retirar el include de `flutter_lints` de `analysis_options.yaml` y ejecutar `flutter pub get` para actualizar `pubspec.lock`.

## Phase 2: Foundational

**Purpose**: Crear los contratos puros de dominio que ambas historias necesitan.

- [x] T002 [P] Crear `EstrategiaRedondeo` de un solo mÃ©todo en `lib/domain/estrategia_redondeo.dart`; usar identificadores abiertos `String` para estrategias, sin enum cerrado.
- [x] T003 [P] Crear `Cuenta`, `Resultado` y `CodigoErrorEntrada` con sus invariantes en `lib/domain/cuenta.dart`, `lib/domain/resultado.dart` y `lib/domain/codigo_error_entrada.dart`.
- [x] T004 Crear `ValidarEntrada` en `lib/domain/validar_entrada.dart`; aceptar texto de monto, personas y propina, devolver `Cuenta` o un cÃ³digo de error exclusivo y aplicar las reglas documentadas en `specs/001-dividir-cuenta/data-model.md` (depende de T003).

**Checkpoint**: Los tipos y la validaciÃ³n de entrada estÃ¡n definidos en Dart puro; `lib/domain/` no importa Flutter.

## Phase 3: User Story 1 - Calcular el aporte individual (Priority: P1) - MVP

**Goal**: Permitir un cÃ¡lculo vÃ¡lido con propina, selecciÃ³n de estrategia y resultado a dos decimales.

**Independent Test**: Completar los cuatro escenarios numÃ©ricos de `specs/001-dividir-cuenta/spec.md` y confirmar el valor despuÃ©s de tocar Â«CalcularÂ».

### Tests for User Story 1

- [x] T005 [US1] Crear pruebas de dominio en `test/domain/calcular_division_test.dart` para 100/4/10% exacto = 27.50, 90/3/0% exacto = 30.00, 10/3/0% exacto = 3.33 y 10/3/0% hacia arriba = 4.00.
- [x] T006 [US1] Actualizar `test/widget_test.dart` para comprobar que los campos, el botÃ³n Â«CalcularÂ» y ambos modos producen los cuatro resultados numÃ©ricos; aÃ±adir el escenario offline bloqueando peticiones HTTP durante un cÃ¡lculo vÃ¡lido.

### Implementation for User Story 1

- [x] T007 [US1] Crear `CalcularDivision` en `lib/domain/calcular_division.dart`; aplicar la propina, dividir por personas y delegar el ajuste a `EstrategiaRedondeo` sin validar ni formatear.
- [x] T008 [P] [US1] Implementar `RedondeoExacto` en `lib/data/redondeo_exacto.dart` conforme a `EstrategiaRedondeo`.
- [x] T009 [P] [US1] Implementar `RedondeoHaciaArriba` en `lib/data/redondeo_hacia_arriba.dart`; elevar solo si la parte fraccionaria es mayor que cero.
- [x] T010 [P] [US1] Crear `FormateadorMoneda` en `lib/presentation/formateador_moneda.dart` para mostrar USD con dos decimales sin alterar el valor numÃ©rico.
- [x] T011 [US1] Crear `DivisorController` en `lib/presentation/divisor_controller.dart`; recibir por constructor `ValidarEntrada`, `CalcularDivision` y `Map<String, EstrategiaRedondeo>`, seleccionar por identificador sin enum cerrado ni imports de `data`.
- [x] T012 [US1] Crear `PantallaDivisor` en `lib/presentation/pantalla_divisor.dart` con monto, personas, propina, opciones derivadas del registro inyectado y botÃ³n Â«CalcularÂ»; actualizar resultado local mediante `setState` solo al pulsarlo.
- [x] T013 [US1] Componer en `lib/main.dart` `RedondeoExacto`, `RedondeoHaciaArriba`, sus IDs y etiquetas, validaciÃ³n, cÃ¡lculo, controller y pantalla; mantener aquÃ­ la instanciaciÃ³n concreta y el registro abierto.

**Checkpoint**: La historia de cÃ¡lculo vÃ¡lido se puede recorrer independientemente en una sola pantalla.

## Phase 4: User Story 2 - Corregir datos invÃ¡lidos (Priority: P1)

**Goal**: Mostrar errores definidos y ocultar cualquier resultado cuando los datos no son vÃ¡lidos.

**Independent Test**: Probar cero personas y monto Â«abcÂ»; confirmar sus textos exactos y que no aparece un resultado. Comprobar tambiÃ©n que un intento invÃ¡lido borra un resultado anterior.

### Tests for User Story 2

- [x] T014 [P] [US2] Crear `test/domain/validar_entrada_test.dart` para monto vacío/no numérico/negativo, cero o personas inválidas y propina no numérica/negativa; verificar códigos de error y que no se crea una `Cuenta` inválida.
- [x] T015 [US2] Ampliar `test/widget_test.dart` con cero personas y monto `abc`, comprobando los mensajes esperados y la ausencia del resultado.
### Implementation for User Story 2

- [x] T016 [US2] Completar el manejo de errores en `lib/presentation/divisor_controller.dart`; traducir cÃ³digos de `ValidarEntrada` a mensajes en espaÃ±ol, preservar literalmente los dos mensajes especificados y limpiar el resultado al fallar.
- [x] T017 [US2] Actualizar `lib/presentation/pantalla_divisor.dart` para presentar el mensaje de validaciÃ³n correspondiente y no mostrar resultados obsoletos ni calcular con entradas invÃ¡lidas.

**Checkpoint**: Los flujos invÃ¡lidos muestran los errores esperados sin resultado y la historia P1 queda completa.

## Phase 5: Polish & Cross-Cutting Concerns

**Purpose**: Verificar arquitectura, calidad y funcionamiento local/offline una vez autorizada la implementaciÃ³n.

- [x] T018 Ejecutar `flutter analyze` y `flutter test`, resolver hallazgos en los archivos afectados y verificar los pasos de `specs/001-dividir-cuenta/quickstart.md`.
- [ ] T019 Verificar manualmente en modo aviÃ³n un cÃ¡lculo vÃ¡lido segÃºn `specs/001-dividir-cuenta/quickstart.md` y registrar el resultado de las seis pruebas y de la comprobaciÃ³n offline en `bitacora.md`.

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: T001; no depende de otras tareas y prepara dependencias.
- **Foundational (Phase 2)**: depende de T001. T002 y T003 pueden avanzar en paralelo; T004 depende de T003.
- **User Stories (Phase 3+)**: US1 depende de T002, T003 y T004. US2 depende de US1 porque extiende el controller y la pantalla.
- **Polish (Phase 5)**: depende de US1 y US2 completos.

### User Story Dependencies

- **US1 (P1)**: inicia tras Phase 2; es el MVP funcional.
- **US2 (P1)**: sigue a US1 para aÃ±adir validaciÃ³n visible a la misma pantalla.

### Parallel Opportunities

- **Setup/Foundational**: T002 y T003 son paralelizables; T004 espera a T003.
- **US1**: T005 y T006 cubren pruebas de dominio e interfaz. T008, T009 y T010 usan archivos separados tras los contratos del dominio.
- **US2**: T014 y T015 cubren pruebas de dominio e interfaz. T016 y T017 usan archivos distintos; T017 depende de T016.

## Parallel Example: User Story 1

```text
Tras completar Phase 2:
T005 -> test/domain/calcular_division_test.dart
T006 -> test/widget_test.dart

Tras completar T002/T003:
T008 -> lib/data/redondeo_exacto.dart
T009 -> lib/data/redondeo_hacia_arriba.dart
T010 -> lib/presentation/formateador_moneda.dart
```

## Implementation Strategy

### MVP First (User Story 1)

1. Completar Setup y Foundation.
2. Completar US1 para entradas vÃ¡lidas y ambos modos.
3. Validar independientemente los cuatro resultados numÃ©ricos.
4. Continuar con US2 para mensajes y manejo de entradas invÃ¡lidas.

### Incremental Delivery

1. US1 entrega el cÃ¡lculo vÃ¡lido y ambos modos.
2. US2 agrega validaciÃ³n y evita resultados engaÃ±osos.
3. Polish verifica anÃ¡lisis, suite automatizada y ejecuciÃ³n offline.

## Notes

- Las tareas T005, T006, T014 y T015 actualizan pruebas para que los criterios de aceptación sean ejecutables.
- No se modifican `android/` ni `ios/`.
- No se agregan dependencias externas; T001 retira las ya declaradas que el diseÃ±o no necesita.
- `[P]` solo marca tareas independientes en archivos distintos; los IDs siguen el orden de ejecuciÃ³n.
