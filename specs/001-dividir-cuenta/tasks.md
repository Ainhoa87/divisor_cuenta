# Tasks: Dividir cuenta

**Input**: Documentos de diseño en `specs/001-dividir-cuenta/`

**Prerequisites**: `plan.md`, `spec.md`, `research.md`, `data-model.md`, `contracts/ui.md`

**Tests**: La constitución exige pruebas ejecutables para la lógica crítica y los
criterios de aceptación. Las tareas que escriben en `test/` requieren autorización
explícita antes de ejecutarse, conforme a `AGENTS.md`.

**Organization**: Las tareas se agrupan por historia de usuario para permitir la
implementación y verificación incremental.

## Format: `[ID] [P?] [Story] Description`

- `[P]`: tarea paralelizable en archivos distintos y sin dependencias pendientes.
- `[Story]`: historia de usuario asociada.
- Toda tarea concreta identifica sus rutas de archivo.

## Phase 1: Setup

**Purpose**: Dejar el proyecto sin dependencias externas, como pide el plan.

- [ ] T001 Retirar `cupertino_icons` y `flutter_lints` de `pubspec.yaml`, retirar el include de `flutter_lints` de `analysis_options.yaml` y ejecutar `flutter pub get` para actualizar `pubspec.lock`.

## Phase 2: Foundational

**Purpose**: Crear los contratos puros de dominio que ambas historias necesitan.

- [ ] T002 [P] Crear `EstrategiaRedondeo` de un solo método y `ModoRedondeo` en `lib/domain/estrategia_redondeo.dart` y `lib/domain/modo_redondeo.dart`.
- [ ] T003 [P] Crear `Cuenta`, `Resultado` y `CodigoErrorEntrada` con sus invariantes en `lib/domain/cuenta.dart`, `lib/domain/resultado.dart` y `lib/domain/codigo_error_entrada.dart`.
- [ ] T004 Crear `ValidarEntrada` en `lib/domain/validar_entrada.dart`; aceptar texto de monto, personas y propina, devolver `Cuenta` o un código de error exclusivo y aplicar las reglas documentadas en `specs/001-dividir-cuenta/data-model.md` (depende de T003).

**Checkpoint**: Los tipos y la validación de entrada están definidos en Dart puro; `lib/domain/` no importa Flutter.

## Phase 3: User Story 1 - Calcular el aporte individual (Priority: P1) - MVP

**Goal**: Permitir un cálculo válido con propina, selección de estrategia y resultado a dos decimales.

**Independent Test**: Completar los cuatro escenarios numéricos de `specs/001-dividir-cuenta/spec.md` y confirmar el valor después de tocar «Calcular».

### Tests for User Story 1

- [ ] T005 [US1] (Requiere autorización para modificar `test/`) Crear pruebas de dominio en `test/domain/calcular_division_test.dart` para 100/4/10% exacto = 27.50, 90/3/0% exacto = 30.00, 10/3/0% exacto = 3.33 y 10/3/0% hacia arriba = 4.00.
- [ ] T006 [US1] (Requiere autorización para modificar `test/`) Actualizar `test/widget_test.dart` para comprobar que los campos, los dos modos y el botón «Calcular» producen los cuatro resultados numéricos de la historia.

### Implementation for User Story 1

- [ ] T007 [US1] Crear `CalcularDivision` en `lib/domain/calcular_division.dart`; aplicar la propina, dividir por personas y delegar el ajuste a `EstrategiaRedondeo` sin validar ni formatear.
- [ ] T008 [P] [US1] Implementar `RedondeoExacto` en `lib/data/redondeo_exacto.dart` conforme a `EstrategiaRedondeo`.
- [ ] T009 [P] [US1] Implementar `RedondeoHaciaArriba` en `lib/data/redondeo_hacia_arriba.dart`; elevar solo si la parte fraccionaria es mayor que cero.
- [ ] T010 [P] [US1] Crear `FormateadorMoneda` en `lib/presentation/formateador_moneda.dart` para mostrar USD con dos decimales sin alterar el valor numérico.
- [ ] T011 [US1] Crear `DivisorController` en `lib/presentation/divisor_controller.dart`; recibir por constructor `ValidarEntrada`, `CalcularDivision` y estrategias tipadas por `EstrategiaRedondeo`, seleccionadas mediante `ModoRedondeo`.
- [ ] T012 [US1] Crear `PantallaDivisor` en `lib/presentation/pantalla_divisor.dart` con monto, personas, propina, modos Exacto/Hacia arriba y botón «Calcular»; actualizar resultado local mediante `setState` solo al pulsar el botón.
- [ ] T013 [US1] Componer en `lib/main.dart` `RedondeoExacto`, `RedondeoHaciaArriba`, validación, cálculo, controller y pantalla; mantener aquí la instanciación concreta.

**Checkpoint**: La historia de cálculo válido se puede recorrer independientemente en una sola pantalla.

## Phase 4: User Story 2 - Corregir datos inválidos (Priority: P1)

**Goal**: Mostrar errores definidos y ocultar cualquier resultado cuando los datos no son válidos.

**Independent Test**: Probar cero personas y monto «abc»; confirmar sus textos exactos y que no aparece un resultado. Comprobar también que un intento inválido borra un resultado anterior.

### Tests for User Story 2

- [ ] T014 [P] [US2] (Requiere autorización para modificar `test/`) Crear `test/domain/validar_entrada_test.dart` para monto vacío/no numérico/negativo, cero o personas inválidas y propina no numérica/negativa; verificar el código de error y que no se construye una `Cuenta` inválida.
- [ ] T015 [US2] (Requiere autorización para modificar `test/`) Ampliar `test/widget_test.dart` con los escenarios de cero personas y monto «abc», comprobando «Debe haber al menos una persona», «Monto inválido» y ausencia del resultado.

### Implementation for User Story 2

- [ ] T016 [US2] Completar el manejo de errores en `lib/presentation/divisor_controller.dart`; traducir códigos de `ValidarEntrada` a mensajes en español, preservar literalmente los dos mensajes especificados y limpiar el resultado al fallar.
- [ ] T017 [US2] Actualizar `lib/presentation/pantalla_divisor.dart` para presentar el mensaje de validación correspondiente y no mostrar resultados obsoletos ni calcular con entradas inválidas.

**Checkpoint**: Los flujos inválidos muestran los errores esperados sin resultado y la historia P1 queda completa.

## Phase 5: Polish & Cross-Cutting Concerns

**Purpose**: Verificar arquitectura, calidad y funcionamiento local/offline una vez autorizada la implementación.

- [ ] T018 Ejecutar `flutter analyze` y `flutter test`, resolver hallazgos en los archivos afectados y verificar los pasos de `specs/001-dividir-cuenta/quickstart.md`.
- [ ] T019 Verificar manualmente en modo avión un cálculo válido según `specs/001-dividir-cuenta/quickstart.md` y registrar el resultado de las seis pruebas y de la comprobación offline en `bitacora.md`.

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: T001; no depende de otras tareas y prepara dependencias.
- **Foundational (Phase 2)**: depende de T001. T002 y T003 pueden avanzar en paralelo; T004 depende de T003.
- **User Stories (Phase 3+)**: US1 depende de T002, T003 y T004. US2 depende de US1 porque extiende el controller y la pantalla.
- **Polish (Phase 5)**: depende de US1 y US2 completos.

### User Story Dependencies

- **US1 (P1)**: inicia tras Phase 2; es el MVP funcional.
- **US2 (P1)**: sigue a US1 para añadir validación visible a la misma pantalla.

### Parallel Opportunities

- **Setup/Foundational**: T002 y T003 son paralelizables; T004 espera a T003.
- **US1**: T005 y T006 usan archivos de prueba separados y pueden ejecutarse en paralelo tras autorizar `test/`. T008, T009 y T010 usan archivos separados y pueden implementarse en paralelo después de los contratos del dominio.
- **US2**: T014 y T015 usan archivos de prueba separados; ambas requieren autorización para `test/`. T016 y T017 usan archivos distintos, pero T017 depende del resultado de T016.

## Parallel Example: User Story 1

```text
Tras autorizar cambios en test/ y completar Phase 2:
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
2. Completar US1 para entradas válidas y ambos modos.
3. Validar independientemente los cuatro resultados numéricos.
4. Continuar con US2 para mensajes y manejo de entradas inválidas.

### Incremental Delivery

1. US1 entrega el cálculo válido y ambos modos.
2. US2 agrega validación y evita resultados engañosos.
3. Polish verifica análisis, suite automatizada y ejecución offline.

## Notes

- Las tareas T005, T006, T014 y T015 no deben modificar `test/` hasta recibir autorización explícita.
- No se modifican `android/` ni `ios/`.
- No se agregan dependencias externas; T001 retira las ya declaradas que el diseño no necesita.
- `[P]` solo marca tareas independientes en archivos distintos; los IDs siguen el orden de ejecución.
