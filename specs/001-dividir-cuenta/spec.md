# Especificación de la función: Dividir cuenta

**Feature Branch**: `sdd` (rama activa al crear la especificación)

**Created**: 2026-10-06

**Status**: Draft

**Input**: User description: "Una app de una sola pantalla para dividir la cuenta de un restaurante entre varias personas. El usuario ingresa el monto total, el número de personas y el porcentaje de propina, y al tocar Calcular ve cuánto paga cada persona con dos decimales. Puede elegir entre redondeo exacto o hacia arriba al entero más cercano. Funciona sin conexión y no usa red ni base de datos."

## User Scenarios & Testing

### User Story 1 - Calcular el aporte individual (Priority: P1)

Como usuario que comparte una cuenta, quiero ingresar el monto, cuántas personas
la comparten y la propina para conocer cuánto debe pagar cada una.

**Why this priority**: Es el propósito principal de la aplicación.

**Independent Test**: Ingresar datos válidos, seleccionar un modo de redondeo y
tocar «Calcular»; comprobar el importe individual mostrado.

**Acceptance Scenarios**:

1. **Given** un monto de 100.00, 4 personas, 10 % de propina y modo exacto,
   **When** el usuario toca «Calcular», **Then** se muestra 27.50 por persona.
2. **Given** un monto de 90.00, 3 personas, 0 % de propina y modo exacto,
   **When** el usuario toca «Calcular», **Then** se muestra 30.00 por persona.
3. **Given** un monto de 10.00, 3 personas, 0 % de propina y modo exacto,
   **When** el usuario toca «Calcular», **Then** se muestra 3.33 por persona.
4. **Given** un monto de 10.00, 3 personas, 0 % de propina y modo hacia arriba,
   **When** el usuario toca «Calcular», **Then** se muestra 4.00 por persona.
5. **Given** valores válidos y el dispositivo sin conexión a Internet,
   **When** el usuario calcula la cuenta, **Then** obtiene el mismo resultado
   sin requerir conexión.

---

### User Story 2 - Corregir datos inválidos (Priority: P1)

Como usuario, quiero recibir un mensaje claro cuando los datos no permitan
calcular para poder corregirlos sin confundirlos con un resultado.

**Why this priority**: Evita presentar un importe que no corresponde a una
cuenta calculable.

**Independent Test**: Probar datos inválidos y verificar el mensaje indicado y
que no se presente ningún resultado.

**Acceptance Scenarios**:

1. **Given** un monto de 50.00 y 0 personas, **When** el usuario toca «Calcular»,
   **Then** se muestra «Debe haber al menos una persona» y no se muestra resultado.
2. **Given** que el monto ingresado es «abc», **When** el usuario toca «Calcular»,
   **Then** se muestra «Monto inválido» y no se muestra resultado.
3. **Given** un monto o porcentaje de propina negativo, **When** el usuario toca
   «Calcular», **Then** la aplicación rechaza los datos y no muestra resultado.

### Edge Cases

- Si el monto está vacío o no es numérico, no se calcula y se informa «Monto inválido».
- Si el número de personas es cero o negativo, no se calcula y se informa
  «Debe haber al menos una persona».
- El monto y la propina no pueden ser negativos; la propina debe ser un número.
- Si se intenta calcular con datos inválidos después de un cálculo válido, no se
  debe dejar visible el resultado anterior como si correspondiera a los nuevos datos.
- El modo hacia arriba redondea el importe individual después de dividir el total
  con propina al siguiente entero; el resultado se muestra con dos decimales.

## Requirements

### Functional Requirements

- **FR-001**: La aplicación MUST permitir ingresar el monto total de la cuenta,
  el número de personas y el porcentaje de propina.
- **FR-002**: La aplicación MUST permitir elegir entre los modos de redondeo
  exacto y hacia arriba al entero siguiente.
- **FR-003**: La aplicación MUST realizar el cálculo únicamente cuando el usuario
  toque «Calcular».
- **FR-004**: La aplicación MUST calcular el total con propina como el monto
  ingresado más el porcentaje de propina sobre ese monto, y dividirlo entre las
  personas.
- **FR-005**: En modo exacto, la aplicación MUST mostrar el aporte individual
  con dos decimales.
- **FR-006**: En modo hacia arriba, la aplicación MUST elevar el aporte individual
  al siguiente entero cuando tenga parte fraccionaria y mostrarlo con dos decimales.
- **FR-007**: Si el número de personas es menor que uno, la aplicación MUST
  mostrar «Debe haber al menos una persona» y no mostrar resultado.
- **FR-008**: Si el monto está vacío o no es un número válido, la aplicación MUST
  mostrar «Monto inválido» y no mostrar resultado.
- **FR-009**: La aplicación MUST rechazar montos o porcentajes de propina
  negativos, y no calcular mientras alguno de esos datos sea inválido.
- **FR-010**: La aplicación MUST funcionar sin conexión a Internet y no depender
  de red ni de una base de datos para dividir la cuenta.
- **FR-011**: La aplicación MUST presentar el cálculo y los mensajes de validación
  en una sola pantalla.

### Key Entities

- **Datos de la cuenta**: monto total, número de personas, porcentaje de propina
  y modo de redondeo usados para un cálculo.
- **Resultado del reparto**: aporte individual calculado y presentado al usuario
  con dos decimales.

## Success Criteria

### Measurable Outcomes

- **SC-001**: Los cuatro escenarios numéricos proporcionados por el usuario
  muestran los importes esperados, incluidos 27.50, 30.00, 3.33 y 4.00.
- **SC-002**: El 100 % de los escenarios con monto o número de personas inválidos
  muestra el mensaje especificado y deja el resultado oculto.
- **SC-003**: El usuario puede completar un cálculo válido en una sola pantalla
  con una acción explícita en «Calcular».
- **SC-004**: El cálculo devuelve sus resultados esperados cuando el dispositivo
  está sin conexión a Internet.

## Assumptions

- El monto y el porcentaje de propina aceptan valores numéricos no negativos;
  el número de personas debe ser un entero positivo.
- En modo exacto se muestra el importe dividido con dos posiciones decimales.
- En modo hacia arriba se redondea el importe individual al siguiente entero
  solo si tiene parte fraccionaria; por eso 4 se presenta como 4.00.
- No se requiere conservar los datos ni el resultado después de cerrar la app.
- Los mensajes de validación distintos de los dos indicados literalmente por el
  usuario pueden ser claros y breves.
